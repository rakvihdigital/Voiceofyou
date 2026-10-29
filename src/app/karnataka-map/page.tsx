import type {Metadata} from 'next';
import PublicSite from '@/components/public-site';
export const metadata:Metadata={title:'Karnataka Map | Voice of You'};
export default function Page(){return <PublicSite key="map" initialView="map"/>;}
