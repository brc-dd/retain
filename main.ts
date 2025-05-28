import $ from 'jsr:@david/dax'
import { expandGlob } from 'jsr:@std/fs'

const root = Deno.env.get('HOME')!

const list = (await Deno.readTextFile('./include.txt')).split('\n').map((_) => _.trim())
  .filter(Boolean)

const exclude = (await Deno.readTextFile('./exclude.txt')).split('\n').map((_) => _.trim())
  .filter(Boolean)

await $`brew bundle dump --global --force`

for await (
  const e of expandGlob('**/*', { root, includeDirs: false, followSymlinks: false, exclude })
) e.isFile && list.push(e.path.slice(root.length + 1))

await Deno.writeTextFile('backup.txt', list.join('\n'))

await $`cd ~; rm -f .retain/backup.zip; zip -r .retain/backup.zip -@ < .retain/backup.txt`
  .noThrow(12, 18)
await $`mv ~/.retain/backup.zip ~/Library/Mobile\\ Documents/com~apple~CloudDocs/backup.zip`
