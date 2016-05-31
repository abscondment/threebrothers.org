# threebrothers.org

## hakyll development environment

### Install nix

[nix](https://nixos.org/nix/) is an awesome package manager that already knows about (and contanies binaries of) 99% of Haskell libraries. It also lets you install multiple versions of the same library and create sandbox environments that only see the desired one.

```shell
curl https://nixos.org/nix/install | sh
```

[append nix bashrc foo]

[restart shell]

### Set up Haskell

#### Configure nix/haskell packaging

We're going to tell `nix` to include certain Haskell packages by default with the Haskell compiler, GHC, via a custom package called `myHaskellEnv`. Also, we'll tell it that we're OK with building unfree projects (e.g. our own).

Create `~/.nixpkgs/config.nix` with the following contents:

```config
{
  packageOverrides = super: let self = super.pkgs; in
  {
     myHaskellEnv =
     self.haskellPackages.ghcWithPackages
        (haskellPackages: with haskellPackages; [
           # potentially add other haskell packages here
           # mtl QuickCheck random text alex cpphs happy ghc-paths
           # hfsevents zlib
           cabal-install stack yesod-bin yesod-test_1_4_4
        ]);
  };
  allowUnfree = true;
}
```

#### Set a better nix binary cache

Now, let's tell nix to use a binary cache. This will let us download prebuilt Haskell things for OS X instead of going all Gentoo and compiling the world.

```shell
sudo mkdir -p /etc/nix
sudo chown $(whoami) /etc/nix
echo "trusted-binary-caches = http://hydra.nixos.org" > /etc/nix/nix.conf
```

#### Actually install

Finally, actually install our GHC and `cabal2nix`, a sandbox helper.

```shell
nix-env -iA nixpkgs.myHaskellEnv \
            nixpkgs.haskellPackages.cabal2nix \
            --option extra-binary-caches http://hydra.nixos.org
```

### Build binary

```shell
nix-shell --option extra-binary-caches http://hydra.nixos.org
cabal update
cabal configure
cabal build
```

### OSX idiosyncracies

#### nixpkgs version

At present (2016-05-31), the `nixpkgs-unstable` channel (nixpkgs-16.09pre83147.df89584) breaks on OSX because it attempts to depend on linux-utils, which is incompatible with darwin. I resovled this issue by using the latest stable release:

```shell
$ nix-channel --list
nixpkgs https://nixos.org/channels/nixos-16.03
```

#### linking Cocoa

The standard shell.nix will produce the following error:

`ld: framework not found Cocoa`

One must add the Cocoa framework as a dependency:

```
executableToolDepends = [ pkgs.darwin.apple_sdk.frameworks.Cocoa ];
```
