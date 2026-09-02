import { NextRequest, NextResponse } from 'next/server';
import { currentUser } from '@/lib/data/seed';
import { recommendedRoles } from '@/lib/domain/recommendations';

export async function POST(request: NextRequest){
  const body = await request.json().catch(()=>null) as {message?:string}|null;
  const message=body?.message?.trim();
  if(!message) return NextResponse.json({error:'message is required'},{status:400});
  const lower=message.toLowerCase();
  let answer='Sea N Shore AI can help with maritime career paths, interview preparation, CV positioning, professional learning and explainers.';
  if(lower.includes('shore')||lower.includes('career')) answer=`Potential shore paths: ${recommendedRoles(currentUser).join(', ')}. Build evidence around judgement, assurance, leadership and commercial awareness.`;
  if(lower.includes('sire')) answer='SIRE 2.0 preparation should connect question intent to actual practice and evidence: procedures, records, familiarisation, recent examples and officer understanding.';
  return NextResponse.json({answer,mode:process.env.AI_PROVIDER_API_KEY?'provider-ready':'safe-fallback'});
}
