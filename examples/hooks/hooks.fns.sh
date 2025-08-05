put_guard() {
  tech="${TECH:-}"; pipeline="${PIPELINE:-}"; top="${pipeline%%/*}"; f="${0##*/}"
  case "$f" in
    "${tech}--"*) : ;;
    *"--${top}--"*) : ;;
    *"--"*) exit 0 ;;
    *) : ;;
  esac
}
