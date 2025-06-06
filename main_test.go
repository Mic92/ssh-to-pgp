package main

import (
	"fmt"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"runtime"
	"testing"
)

// ok fails the test if an err is not nil.
func ok(tb testing.TB, err error) {
	if err != nil {
		_, file, line, _ := runtime.Caller(1)
		fmt.Printf("\033[31m%s:%d: unexpected error: %s\033[39m\n\n", filepath.Base(file), line, err.Error())
		tb.FailNow()
	}
}

func TempRoot() string {
	if runtime.GOOS == "darwin" {
		// macOS make its TEMPDIR long enough for unix socket to break
		return "/tmp"
	} else {
		return os.TempDir()
	}
}

func TestCli(t *testing.T) {
	assets := os.Getenv("TEST_ASSETS")
	if assets == "" {
		assets = "test-assets"
	}
	tempdir, err := os.MkdirTemp(TempRoot(), "testdir")
	ok(t, err)
	defer func() {
		if err = os.RemoveAll(tempdir); err != nil {
			fmt.Println("failed to remove tempdir:", err)
		}
	}()

	gpgHome := path.Join(tempdir, "gpg-home")
	gpgEnv := append(os.Environ(), fmt.Sprintf("GNUPGHOME=%s", gpgHome))
	ok(t, os.Mkdir(gpgHome, os.FileMode(0o700)))

	out := path.Join(tempdir, "out")
	privKey := path.Join(assets, "id_rsa")
	cmds := [][]string{
		{"ssh-to-pgp", "-i", privKey, "-o", out},
		{"ssh-to-pgp", "-format=binary", "-i", privKey, "-o", out},
		{"ssh-to-pgp", "-private-key", "-i", privKey, "-o", out},
		{"ssh-to-pgp", "-format=binary", "-private-key", "-i", privKey, "-o", out},
	}
	for _, cmd := range cmds {
		// Make sure we clean the states between each command
		exec.Command("rm", "-rf", gpgHome+"/*")
		err = convertKeys(cmd)
		ok(t, err)
		cmd := exec.Command("gpg", "--with-fingerprint", "--show-key", out)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Env = gpgEnv
		ok(t, cmd.Run())
		// Try to import the key we've produced
		cmdImport := exec.Command("gpg", "--import", out)
		cmdImport.Stdout = os.Stdout
		cmdImport.Stderr = os.Stderr
		cmdImport.Env = gpgEnv
		ok(t, cmdImport.Run())
	}
}
