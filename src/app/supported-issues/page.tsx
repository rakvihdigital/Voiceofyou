import type {Metadata} from 'next';
import PublicSite from '@/components/public-site';
export const metadata:Metadata={title:'Supported Issues | Voice of You'};
export default function Page(){return <PublicSite key="saved" initialView="saved"/>;}
