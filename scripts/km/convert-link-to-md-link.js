let args = process.argv.slice(2)
let link = args[0]

let exit = (res) => {
  console.log(res)
  process.exit()
}

if (link.match(/^https?:\/\/\S+/)) {
  exit(link.replace(/(https?:\/\/\S+)/, "[link]($1)"))
}

exit(link)


