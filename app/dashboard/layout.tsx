import { getSessionProfile } from '@/lib/auth';import { redirect } from 'next/navigation'
export default async function DashboardLayout({children}:{children:React.ReactNode}){const {user}=await getSessionProfile();if(!user)redirect('/login');return <main className="container-page py-12">{children}</main>}
