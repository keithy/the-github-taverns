put_guard() {
  tech=""; pipeline=""; top=""; f="bash"
  case "" in
    "--"*) : ;;
    *"----"*) : ;;
    *"--"*) exit 0 ;;
    *) : ;;
  esac
}
