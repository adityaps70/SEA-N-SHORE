import { Feed } from '@/components/feed';
import { Card } from '@/components/ui';
import { courses, currentUser, events, jobs, posts, profiles } from '@/lib/data/seed';
import Link from 'next/link';
import { ArrowRight, CalendarDays, GraduationCap, Sparkles } from 'lucide-react';

export const metadata = { title: 'Home' };
export default function HomePage(){
  return <div className="space-y-4">
    <section className="sns-card overflow-hidden">
      <div className="sns-cover relative p-6 text-white sm:p-7">
        <div className="relative z-10 max-w-2xl">
          <span className="rounded-full border border-white/15 bg-white/10 px-3 py-1.5 text-[11px] font-black uppercase tracking-[.12em] text-[#a8e2ed]">Your maritime network</span>
          <h1 className="mt-4 text-3xl font-black tracking-[-.04em] sm:text-4xl">Build reputation before you need the next opportunity.</h1>
          <p className="mt-3 max-w-xl text-sm leading-6 text-white/70">Share practical knowledge, grow the right professional graph, and let jobs, mentors and learning find you through your maritime identity.</p>
        </div>
      </div>
    </section>
    <div className="grid gap-3 sm:grid-cols-3">
      <Card className="p-4"><div className="flex items-start justify-between"><div><div className="text-xs font-black uppercase tracking-[.1em] text-[#7c90a0]">Best job match</div><div className="mt-2 font-black text-[#173b59]">{jobs[0].title}</div><div className="mt-1 text-xs text-[#6f8495]">{jobs[0].match}% match · {jobs[0].company}</div></div><Sparkles size={19} className="text-[#1167d8]"/></div><Link href="/jobs" className="mt-3 inline-flex items-center gap-1 text-xs font-black text-[#1167d8]">View role <ArrowRight size={13}/></Link></Card>
      <Card className="p-4"><div className="flex items-start justify-between"><div><div className="text-xs font-black uppercase tracking-[.1em] text-[#7c90a0]">Continue learning</div><div className="mt-2 font-black text-[#173b59]">{courses[0].title}</div><div className="mt-1 text-xs text-[#6f8495]">{courses[0].progress}% complete</div></div><GraduationCap size={19} className="text-[#1167d8]"/></div><Link href="/learn" className="mt-3 inline-flex items-center gap-1 text-xs font-black text-[#1167d8]">Resume course <ArrowRight size={13}/></Link></Card>
      <Card className="p-4"><div className="flex items-start justify-between"><div><div className="text-xs font-black uppercase tracking-[.1em] text-[#7c90a0]">Upcoming event</div><div className="mt-2 font-black text-[#173b59]">{events[0].title}</div><div className="mt-1 text-xs text-[#6f8495]">{events[0].date} · {events[0].time}</div></div><CalendarDays size={19} className="text-[#1167d8]"/></div><Link href="/events" className="mt-3 inline-flex items-center gap-1 text-xs font-black text-[#1167d8]">View events <ArrowRight size={13}/></Link></Card>
    </div>
    <Feed currentUser={currentUser} initialPosts={posts} initialProfiles={profiles}/>
  </div>
}
