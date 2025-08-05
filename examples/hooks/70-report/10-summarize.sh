tech="${TECH:-}"; type="${ITEM_TYPE:-}"; pipeline="${PIPELINE:-}"
top="${pipeline%%/*}"
f="${0##*/}"
case "the-github-taverns/examples/hooks/70-report/10-summarize.sh" in
  "${tech}--"*) : ;;
  *"--${type}--"*) : ;;
  *"--"*) exit 0 ;;
  *) : ;;
esac
echo "all techs: 10-summarize"
