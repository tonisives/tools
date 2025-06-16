import fs from "fs"

let args = process.argv.slice(2)

let fullPath = args[0]

console.log(`fullPath ${fullPath}`)

let folder = fullPath.split("/").slice(0, -1).join("/")
let file = fullPath.split("/").slice(-1).at(0)
let newName = file.replaceAll(" ", "-").toLowerCase()
let newPath = `${folder}/${newName}`

console.log(`newPath ${newPath}`)

fs.rename(fullPath, newPath, (err) => {
  console.log(err)
})
