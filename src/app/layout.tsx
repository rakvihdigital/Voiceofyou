import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title: 'Voice of You | A better Karnataka starts with you', description: 'An independent citizen platform to report civic issues, follow progress, and build a better Karnataka. Available in English, Kannada and Hindi.' };
export default function RootLayout({children}:{children:React.ReactNode}) { return <html lang="en"><body>{children}</body></html>; }
