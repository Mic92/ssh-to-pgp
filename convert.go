package main

import (
	"crypto"
	"crypto/rsa"
	"fmt"
	"reflect"
	"time"

	"github.com/ProtonMail/go-crypto/openpgp"
	"github.com/ProtonMail/go-crypto/openpgp/packet"
	"golang.org/x/crypto/ssh"
)

func parsePrivateKey(sshPrivateKey []byte) (*rsa.PrivateKey, error) {
	privateKey, err := ssh.ParseRawPrivateKey(sshPrivateKey)
	if err != nil {
		return nil, err
	}

	rsaKey, ok := privateKey.(*rsa.PrivateKey)

	if !ok {
		return nil, fmt.Errorf("only RSA keys are supported right now, got: %s", reflect.TypeOf(privateKey))
	}

	return rsaKey, nil
}

func SSHPrivateKeyToPGP(sshPrivateKey []byte, name string, comment string, email string) (*openpgp.Entity, error) {
	key, err := parsePrivateKey(sshPrivateKey)
	if err != nil {
		return nil, fmt.Errorf("failed to parse private ssh key: %w", err)
	}

	// Let's make keys reproducible
	timeNull := time.Unix(0, 0)

	gpgKey := &openpgp.Entity{
		PrimaryKey: packet.NewRSAPublicKey(timeNull, &key.PublicKey),
		PrivateKey: packet.NewRSAPrivateKey(timeNull, key),
		Identities: make(map[string]*openpgp.Identity),
	}
	uid := packet.NewUserId(name, comment, email)
	if uid == nil {
		return nil, fmt.Errorf("userid contains invalid characters (i.e. '\x00', '(', ')', '<' and '>'): name='%s' comment='%s' email='%s'", name, comment, email)
	}
	isPrimaryID := true
	selfSignature := &packet.Signature{
		CreationTime:              timeNull,
		SigType:                   packet.SigTypePositiveCert,
		PubKeyAlgo:                packet.PubKeyAlgoRSA,
		Hash:                      crypto.SHA256,
		IsPrimaryId:               &isPrimaryID,
		FlagsValid:                true,
		FlagSign:                  true,
		FlagCertify:               true,
		FlagEncryptStorage:        true,
		FlagEncryptCommunications: true,
		IssuerKeyId:               &gpgKey.PrimaryKey.KeyId,
	}
	gpgKey.Identities[uid.Id] = &openpgp.Identity{
		Name:          uid.Id,
		UserId:        uid,
		SelfSignature: selfSignature,
		Signatures:    []*packet.Signature{selfSignature},
	}
	err = gpgKey.Identities[uid.Id].SelfSignature.SignUserId(uid.Id, gpgKey.PrimaryKey, gpgKey.PrivateKey, nil)
	if err != nil {
		return nil, err
	}

	return gpgKey, nil
}
