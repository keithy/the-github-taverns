tech="${TECH:-}"; type="${ITEM_TYPE:-}"; pipeline="${PIPELINE:-}"
top="${pipeline%%/*}"
f="${0##*/}"
case "the-github-taverns/examples/hooks/40-pre-publish/10-prepare-metadata.sh" in
  "${tech}--"*) : ;;
  *"--${type}--"*) : ;;
  *"--"*) exit 0 ;;
  *) : ;;
esac
echo "all techs: 10-prepare-metadata"
