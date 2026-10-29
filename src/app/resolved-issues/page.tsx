import type {Metadata} from 'next';
import PublicSite from '@/components/public-site';
export const metadata:Metadata={title:'Resolved Issues | Voice of You'};
export default function Page(){return <PublicSite key="resolved" initialView="resolved"/>;}
