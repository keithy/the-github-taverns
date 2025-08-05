tech="${TECH:-}";  pipeline="${PIPELINE:-}"
top="${pipeline%%/*}"
f="${0##*/}"
case "the-github-taverns/examples/hooks/40-pre-publish/docker--20-login.sh" in
  "${tech}--"*) : ;;
  *"--${top}--"*) : ;;
  *"--"*) exit 0 ;;
  *) : ;;
esac
echo "docker only: 20-login"
