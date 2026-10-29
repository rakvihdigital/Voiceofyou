import type {Metadata} from 'next';
import PublicSite from '@/components/public-site';
export const metadata:Metadata={title:'Help and Resources | Voice of You'};
export default function Page(){return <PublicSite key="help" initialView="help"/>;}
