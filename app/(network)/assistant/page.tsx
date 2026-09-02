import { AIAssistant } from '@/components/ai-assistant';
import { Card } from '@/components/ui';
import { BriefcaseBusiness, FileSearch, GraduationCap, MessagesSquare } from 'lucide-react';
export const metadata = { title: 'AI Maritime Assistant' };
const shortcuts=[['Career paths',BriefcaseBusiness],['Interview prep',MessagesSquare],['CV review',FileSearch],['Learning plan',GraduationCap]] as const;
export default function AssistantPage(){return <div className="space-y-4"><div><div className="sns-page-title">AI Maritime Assistant</div><p className="sns-page-copy mt-1">Maritime-context career, learning and professional guidance connected to your Sea N Shore profile.</p></div><div className="grid grid-cols-2 gap-3 sm:grid-cols-4">{shortcuts.map(([label,Icon])=><Card key={label} className="p-3 text-center"><Icon className="mx-auto text-[#1167d8]" size={18}/><div className="mt-2 text-xs font-black text-[#36556e]">{label}</div></Card>)}</div><AIAssistant/></div>}
