git clone https://github.com/Homebrew/brew.git
echo 'eval "$($HOME/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
source ~/.bash_profile
brew install dropbear

ssh-keygen -t rsa -f ~/.ssh/id_rsa -N "" -q
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
dropbearkey -t ecdsa -s 521 -f ~/.ssh/server-key
