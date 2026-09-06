import type { Config } from 'tailwindcss'
const config: Config = { content: ['./app/**/*.{js,ts,jsx,tsx,mdx}','./components/**/*.{js,ts,jsx,tsx,mdx}'], theme: { extend: { colors: { ink:'#17211b', cream:'#fffaf0', leaf:'#2f6b4f', sun:'#f4a340', coral:'#e56b5d' }, boxShadow:{soft:'0 18px 50px rgba(23,33,27,.10)'} } }, plugins: [] }
export default config
