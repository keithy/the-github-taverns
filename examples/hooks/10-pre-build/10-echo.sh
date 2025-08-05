tech="${TECH:-}";  pipeline="${PIPELINE:-}"
top="${pipeline%%/*}"
f="${0##*/}"
case "the-github-taverns/examples/hooks/10-pre-build/10-echo.sh" in
  "${tech}--"*) : ;;
  *"--${top}--"*) : ;;
  *"--"*) exit 0 ;;
  *) : ;;
esac
echo pre-build
