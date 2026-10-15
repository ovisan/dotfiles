# Login shells read this file and do not read ~/.bashrc unless it is
# sourced from here. On a server, ~/.profile often sources ~/.bashrc
# itself and also sets PATH (~/bin, ~/.local/bin). Load that first.
if [[ -f "${HOME}/.profile" ]]; then
  # shellcheck disable=SC1091
  source "${HOME}/.profile"
fi
if [[ -z "${DOTFILES_BASHRC_LOADED:-}" && -f "${HOME}/.bashrc" ]]; then
  # shellcheck disable=SC1091
  source "${HOME}/.bashrc"
fi
