#!/usr/bin/env -S deno run -A

import $ from 'jsr:@david/dax'
import { expandGlob } from 'jsr:@std/fs'

const root = Deno.env.get('HOME')
if (!root) {
  console.error('HOME environment variable is not set.')
  Deno.exit(1)
}

const list = (await Deno.readTextFile('./include.txt'))
  .split('\n')
  .map((_) => _.trim())
  .filter(Boolean)
  .map((file) => `${root}/${file}`)

const exclude = (await Deno.readTextFile('./exclude.txt'))
  .split('\n')
  .map((_) => _.trim())
  .filter(Boolean)

await $`brew bundle dump --global --force`

for await (const e of expandGlob('**/*', {
  root,
  includeDirs: false,
  followSymlinks: false,
  exclude
}))
  e.isFile && list.push(e.path)

try {
  await Deno.mkdir(`${root}/.retain`, { recursive: true })
} catch (error) {
  if (!(error instanceof Deno.errors.AlreadyExists)) {
    console.error('Error creating .retain directory:', error)
    Deno.exit(1)
  }
}

await Deno.writeTextFile(`${root}/.retain/backup.txt`, list.join('\n'))
await $`cd ~; zip -r .retain/backup.zip -@ < .retain/backup.txt`.noThrow(18, 12)
await $`cd ~; cp .retain/backup.zip "$HOME/Library/Mobile Documents/com~apple~CloudDocs/backup.zip"`
