let
  pwnwriter = "ssh-ed25519 aaaac3nzac1lzdi1nte5aaaailr9gkvky8ax9bbqv0tfwcpk31km7vuurnitttzpdfis agenix@pwnwriter";
in
{
  "ssh-key.age".publicKeys = [ pwnwriter ];
  "gpg-key.age".publicKeys = [ pwnwriter ];
}
