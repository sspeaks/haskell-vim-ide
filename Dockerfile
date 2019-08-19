FROM sspeaks/personal:haskell-hie-all

# Install Neovim
RUN apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:neovim-ppa/unstable -y && \
    apt-get install neovim -y

# Install Haskell Dependencies
RUN stack install hlint stylish-haskell && \
    stack --resolver=nightly install apply-refact

# Install Node
RUN curl -sL install-node.now.sh/lts > lts && bash lts --yes && rm lts

# Install Plugged
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy config
COPY init.vim /root/.config/nvim/
COPY coc-settings.json /root/.config/nvim/

# Install plugins
RUN apt-get install dos2unix -y && \
    dos2unix /root/.config/nvim/* && \
    nvim +PlugInstall +qall

# setup alias and stylish-haskell config
RUN stylish-haskell --defaults > ~/.stylish-haskell.yaml && \
    sed -i 's/# - tabs:/- tabs:/' /root/.stylish-haskell.yaml && \
    sed -i 's/#     spaces: 8/     spaces: 8/' /root/.stylish-haskell.yaml && \
    echo 'alias vim=nvim' > /root/.bash_aliases