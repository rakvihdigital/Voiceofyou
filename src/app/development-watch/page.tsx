import type {Metadata} from 'next';
import PublicSite from '@/components/public-site';
export const metadata:Metadata={title:'Development Watch | Voice of You'};
export default function Page(){return <PublicSite key="watch" initialView="watch"/>;}
