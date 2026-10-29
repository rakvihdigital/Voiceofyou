import type {Metadata} from 'next';
import AdminPanel from '@/components/admin-panel';
export const metadata:Metadata={title:'Admin Workspace | Voice of You',robots:{index:false,follow:false}};
export default function Page(){return <AdminPanel/>;}
