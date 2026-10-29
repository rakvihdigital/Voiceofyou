import type {Metadata} from 'next';
import PublicSite from '@/components/public-site';
export const metadata:Metadata={title:'My Reports | Voice of You'};
export default function Page(){return <PublicSite key="my" initialView="my"/>;}
