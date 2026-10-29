import type {Metadata} from 'next';
import PublicSite from '@/components/public-site';
export const metadata:Metadata={title:'About the Movement | Voice of You'};
export default function Page(){return <PublicSite key="about" initialView="about"/>;}
