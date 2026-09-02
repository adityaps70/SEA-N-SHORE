import Link from 'next/link';
export function Logo({compact=false}:{compact?:boolean}){
  return <Link href="/home" className="flex items-center gap-2.5 min-w-0">
    <div className="relative h-10 w-10 overflow-hidden rounded-xl bg-[#08233d] text-white shadow-sm">
      <div className="absolute left-1.5 right-1.5 top-3 h-[2px] rounded bg-[#38c1da]" />
      <div className="absolute left-1.5 right-1.5 top-5 h-[2px] rounded bg-white/80" />
      <div className="absolute left-1.5 right-1.5 top-7 h-[2px] rounded bg-[#38c1da]" />
      <span className="absolute left-2 top-0.5 text-[10px] font-black tracking-tight">SN</span>
    </div>
    {!compact && <div className="min-w-0"><div className="truncate text-[15px] font-black tracking-[-.03em] text-[#08233d]">Sea N Shore</div><div className="truncate text-[10px] font-bold uppercase tracking-[.14em] text-[#6c8294]">Global Shipping Community</div></div>}
  </Link>
}
