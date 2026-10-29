import { createClient } from '@supabase/supabase-js';
import { createInterface,emitKeypressEvents } from 'node:readline';
const url=process.env.SUPABASE_URL||process.env.NEXT_PUBLIC_SUPABASE_URL;
const key=process.env.SUPABASE_SERVICE_ROLE_KEY;
if(!url||!key){console.error('Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in this terminal. Never put the service key in NEXT_PUBLIC_ variables.');process.exit(1);}
if(!process.stdin.isTTY){console.error('Run interactively in a terminal to enter the password securely.');process.exit(1);}
const prompt=createInterface({input:process.stdin,output:process.stdout});
const email=await new Promise(resolve=>prompt.question('Admin email: ',resolve));prompt.close();
if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)){console.error('Enter a valid email address.');process.exit(1);}
function readSecret(label){return new Promise(resolve=>{process.stdout.write(label);let secret='';emitKeypressEvents(process.stdin);process.stdin.setRawMode(true);process.stdin.resume();function keypress(text,key){if(key?.ctrl&&key.name==='c'){process.stdout.write('\n');process.exit(130);}if(key?.name==='return'){process.stdin.off('keypress',keypress);process.stdin.setRawMode(false);process.stdin.pause();process.stdout.write('\n');resolve(secret);}else if(key?.name==='backspace'){secret=secret.slice(0,-1);}else if(text&&!key?.ctrl&&!key?.meta&&text.charCodeAt(0)>=32)secret+=text;}process.stdin.on('keypress',keypress);});}
const password=await readSecret('Admin password (hidden, at least 12 characters): ');
const confirmation=await readSecret('Confirm password (hidden): ');
if(password.length<12||password!==confirmation){console.error('Passwords must match and contain at least 12 characters.');process.exit(1);}
const db=createClient(url,key,{auth:{persistSession:false,autoRefreshToken:false}});
const {data,error}=await db.auth.admin.createUser({email,password,email_confirm:true,user_metadata:{display_name:'Platform administrator'}});
if(error){console.error(error.message);process.exit(1);}
const result=await db.from('admin_users').insert({user_id:data.user.id});
if(result.error){const rollback=await db.auth.admin.deleteUser(data.user.id);console.error('Admin role could not be provisioned. Run supabase/admin.sql first. '+(rollback.error?'The newly created account must be removed manually.':'The new account was rolled back.'));process.exit(1);}
console.log('Administrator created. Sign in at /admin/ using the email and password you entered.');
