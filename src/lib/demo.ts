import {issues,type Issue} from './data';
export type ReviewEvent={id:string;reference:string;from:string;to:string;note:string;at:string};
export function readDemoIssues():Issue[]{
 const local:Issue[]=JSON.parse(localStorage.getItem('voy-reports')||'[]');
 const overrides:Record<string,Partial<Issue>>=JSON.parse(localStorage.getItem('voy-admin-overrides')||'{}');
 return [...local,...issues].map(i=>({...i,...overrides[i.id]}));
}
export function readDemoEvents():ReviewEvent[]{return JSON.parse(localStorage.getItem('voy-admin-events')||'[]');}
export function reviewDemoIssue(issue:Issue,status:string,note:string){
 const overrides=JSON.parse(localStorage.getItem('voy-admin-overrides')||'{}');
 const events=readDemoEvents();
 overrides[issue.id]={...overrides[issue.id],status};
 localStorage.setItem('voy-admin-overrides',JSON.stringify(overrides));
 localStorage.setItem('voy-admin-events',JSON.stringify([{id:crypto.randomUUID(),reference:issue.id,from:issue.status,to:status,note,at:new Date().toISOString()},...events]));
}
