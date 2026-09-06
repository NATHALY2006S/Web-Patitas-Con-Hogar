import type { Metadata } from 'next';import './globals.css';import { Navbar } from '@/components/Navbar'
export const metadata:Metadata={title:'Patitas con Hogar',description:'Adopción responsable que conecta refugios y familias'}
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="es"><body><Navbar/>{children}<footer className="mt-20 bg-ink py-10 text-center text-sm text-white/70">Patitas con Hogar · Tecnología para la adopción responsable</footer></body></html>}
