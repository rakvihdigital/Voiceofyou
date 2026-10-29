import type {Metadata} from 'next';
import PublicSite from '@/components/public-site';
export const metadata:Metadata={title:'Explore Issues | Voice of You'};
export default function Page(){return <PublicSite key="explore" initialView="explore"/>;}
