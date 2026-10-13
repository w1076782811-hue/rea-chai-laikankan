import { mkdir } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const skillRoot = dirname(dirname(fileURLToPath(import.meta.url)));
const temporaryRoot = join(skillRoot, 'state', 'temp');
await mkdir(temporaryRoot, { recursive: true });

process.env.TEMP = temporaryRoot;
process.env.TMP = temporaryRoot;

const entryPath = join(skillRoot, 'node_modules', 'rea-agents', 'scripts', 'rea.mjs');
process.argv[1] = entryPath;
await import(pathToFileURL(entryPath).href);
