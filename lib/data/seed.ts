export type Profile = {
  id:string; name:string; initials:string; role:string; company:string; location:string;
  experienceYears:number; vesselTypes:string[]; skills:string[]; certificates:string[];
  verified:string; followers:number; connections:number; reputation:number; summary:string; availability:string;
};
export type Post = {id:string; authorId:string; category:string; time:string; text:string; tags:string[]; likes:number; comments:number; shares:number};
export type Job = {id:string; title:string; company:string; rank:string; vesselType:string; contract:string; salary:string; joining:string; experience:string; location:string; description:string; skills:string[]; applicants:number; match:number};
export type Course = {id:string; title:string; category:string; instructor:string; level:string; lessons:number; duration:string; rating:number; learners:number; price:number; progress:number; description:string; tag:string};

export const currentUser: Profile = {
  id:'u-saurabh', name:'Capt. Saurabh Saraswat', initials:'SS', role:'Master Mariner · Founder, Sea N Shore',
  company:'Sea N Shore Global Shipping Community', location:'India', experienceYears:28,
  vesselTypes:['Oil Tanker','Product Tanker'], skills:['Tanker Operations','SIRE 2.0','TMSA','Navigation Audit','Incident Investigation','Leadership'],
  certificates:['Master Mariner CoC','ISO 9001 Lead Auditor','ISO 14001 Lead Auditor','DPA','CSO','Train the Trainer'],
  verified:'Verified Expert', followers:21460, connections:8472, reputation:5420,
  summary:'Master Mariner and maritime entrepreneur building a trusted global professional ecosystem for seafarers and shore professionals.',
  availability:'Available for mentoring'
};
export const profiles: Profile[] = [currentUser,
  {id:'u-priya',name:'Priya Nair',initials:'PN',role:'Chief Officer · LNG',company:'Ocean Crest Shipping',location:'Kochi, India',experienceYears:12,vesselTypes:['LNG Carrier','Oil Tanker'],skills:['LNG Cargo','SIRE 2.0','Bridge Resource Management'],certificates:['Master FG CoC','Advanced Gas Tanker'],verified:'Verified Seafarer',followers:2640,connections:1830,reputation:3180,summary:'Chief Officer focused on safe cargo operations, leadership and a future transition into vetting.',availability:'45 days'},
  {id:'u-arjun',name:'Arjun Mehta',initials:'AM',role:'Chief Engineer · Product Tankers',company:'BlueWave Tankers',location:'Mumbai, India',experienceYears:16,vesselTypes:['Product Tanker','Chemical Tanker'],skills:['PMS','Dry Docking','Energy Efficiency','Alternative Fuels'],certificates:['Class I Motor CoC','IGF Familiarisation'],verified:'Verified Seafarer',followers:3460,connections:2212,reputation:3620,summary:'Chief Engineer working at the intersection of vessel reliability, decarbonisation and shore transition.',availability:'90 days'},
  {id:'u-elena',name:'Capt. Elena Fernandez',initials:'EF',role:'Vetting & Marine Assurance Director',company:'NorthStar Maritime',location:'Singapore',experienceYears:24,vesselTypes:['Oil Tanker','Chemical Tanker'],skills:['SIRE 2.0','TMSA','Marine Assurance','Leadership'],certificates:['Master Mariner','OCIMF Assessor Training'],verified:'Verified Mentor',followers:11800,connections:6390,reputation:6940,summary:'Former tanker master and marine assurance leader mentoring officers moving into vetting and superintendent roles.',availability:'Slots this week'}
];
export const posts: Post[] = [
  {id:'p1',authorId:'u-priya',category:'Technical Discussion',time:'18 min',text:'5 common SIRE 2.0 observations I keep seeing during pre-vetting preparation: weak evidence trails, generic answers, poor linkage between procedures and actual practice, inconsistent familiarisation, and officers answering beyond their role. Inspectors are testing how the system works in reality—not how polished the manual looks.',tags:['SIRE 2.0','Vetting','Tankers'],likes:284,comments:47,shares:39},
  {id:'p2',authorId:'u-arjun',category:'Industry Opinion',time:'1 h',text:'Decarbonisation training needs to move beyond “what is CII?” Senior engineers now need commercial context: machinery condition, voyage profile, fuel choice, hull performance and operational decisions must be connected to emissions outcomes.',tags:['Decarbonisation','Marine Engineering'],likes:198,comments:31,shares:24},
  {id:'p3',authorId:'u-elena',category:'Career Advice',time:'3 h',text:'A seafarer moving ashore should stop describing only responsibilities and start translating judgement. “Managed cargo operations” is weaker than explaining how you reduced risk, coordinated teams, handled exceptions and improved assurance outcomes.',tags:['Shore Transition','Career'],likes:412,comments:68,shares:91}
];
export const jobs: Job[] = [
  {id:'j1',title:'Marine Superintendent — Tankers',company:'NorthStar Maritime',rank:'Master / Chief Officer',vesselType:'Tanker',contract:'Permanent',salary:'₹28–36 LPA',joining:'Immediate',experience:'2+ years senior rank',location:'Mumbai',description:'Lead marine operations, navigation assurance, incident review and vessel support across a tanker fleet.',skills:['Tanker Operations','SIRE 2.0','TMSA'],applicants:58,match:94},
  {id:'j2',title:'Vetting Inspector',company:'BlueWave Tankers',rank:'Master / Chief Officer',vesselType:'Tanker',contract:'Permanent',salary:'Competitive',joining:'October 2026',experience:'Tanker senior officer',location:'Singapore',description:'Support SIRE preparation, internal assurance, observation analysis and fleet learning.',skills:['SIRE 2.0','Vetting','Marine Assurance'],applicants:43,match:91},
  {id:'j3',title:'Technical Superintendent',company:'Ocean Crest Shipping',rank:'Chief Engineer',vesselType:'Tanker',contract:'Permanent',salary:'₹30–40 LPA',joining:'Immediate',experience:'Senior engineer with tanker background',location:'Gurugram',description:'Manage technical performance, PMS quality, dry-docking and vessel reliability.',skills:['PMS','Dry Docking','Budgeting'],applicants:27,match:74},
  {id:'j4',title:'Maritime Training Manager',company:'Sea N Shore Academy',rank:'Master / Chief Engineer / Trainer',vesselType:'Shore',contract:'Permanent',salary:'₹18–24 LPA',joining:'Immediate',experience:'Training / assessment experience',location:'Remote / India',description:'Own maritime course quality, SME network and assessment standards across technical and leadership programmes.',skills:['Instructional Design','SIRE 2.0','Training'],applicants:19,match:88}
];
export const groups = [
  {id:'g1',name:'Tanker Professionals',members:14820,posts:'2.1k/mo',description:'Operational, vetting and safety conversations for tanker professionals.'},
  {id:'g2',name:'Marine Engineers Community',members:11340,posts:'1.8k/mo',description:'Reliability, troubleshooting, energy efficiency and technical careers.'},
  {id:'g3',name:'Masters & Senior Officers',members:9840,posts:'1.2k/mo',description:'Leadership, command, navigation, regulation and shore transition.'},
  {id:'g4',name:'Women in Maritime',members:6180,posts:'860/mo',description:'Career growth, leadership, mentoring and industry inclusion.'},
  {id:'g5',name:'Shore Career Transition',members:17340,posts:'2.7k/mo',description:'Role discovery, CV positioning, interviews, networking and referrals.'},
  {id:'g6',name:'Maritime Technology',members:7420,posts:'1.1k/mo',description:'AI, digitalisation, cyber, data and future-of-shipping discussions.'}
];
export const courses: Course[] = [
  {id:'cr1',title:'SIRE 2.0: From Procedure to Evidence',category:'Technical',instructor:'Capt. Elena Fernandez',level:'Advanced',lessons:18,duration:'4h 40m',rating:4.9,learners:1840,price:1499,progress:42,description:'A practical officer-focused programme on question intent, evidence, human factors and inspection readiness.',tag:'Most popular'},
  {id:'cr2',title:'TMSA for Senior Officers & Shore Teams',category:'Technical',instructor:'Capt. R. Iyer',level:'Intermediate',lessons:14,duration:'3h 15m',rating:4.8,learners:1120,price:1299,progress:0,description:'Understand TMSA elements through practical fleet examples and improvement actions.',tag:'Company-ready'},
  {id:'cr3',title:'Shore Transition Blueprint',category:'Career Development',instructor:'Sea N Shore Career Team',level:'All levels',lessons:12,duration:'2h 50m',rating:4.9,learners:2740,price:999,progress:68,description:'Translate sea-going experience into shore-role positioning, networking and interview outcomes.',tag:'Career'},
  {id:'cr4',title:'AI in Shipping for Maritime Professionals',category:'Future Skills',instructor:'Dr. Neel Rao',level:'Beginner',lessons:10,duration:'2h 05m',rating:4.7,learners:930,price:799,progress:0,description:'Practical AI use cases in operations, safety, training, maintenance and decision support.',tag:'Future skills'}
];
export const mentors = [
  {id:'m1',name:'Capt. Elena Fernandez',initials:'EF',expertise:['SIRE 2.0','Vetting','Shore Transition'],experience:'24 years',rating:4.9,reviews:118,price:3500,next:'Today · 18:30',bio:'Former tanker master and marine assurance director. Helps senior officers prepare for vetting and superintendent careers.',verified:'Verified Mentor'},
  {id:'m2',name:'C/E Vikram Rao',initials:'VR',expertise:['Technical Superintendent','Dry Docking','PMS'],experience:'21 years',rating:4.8,reviews:86,price:3000,next:'Thu · 20:00',bio:'Fleet technical manager mentoring engineers moving ashore and preparing for superintendent interviews.',verified:'Verified Mentor'},
  {id:'m3',name:'Dr. Maya Sen',initials:'MS',expertise:['Seafarer Wellness','Stress','Family Relationships'],experience:'12 years',rating:4.9,reviews:144,price:1800,next:'Today · 21:00',bio:'Wellness professional focused on long rotations, family separation and stress at sea.',verified:'Verified Expert'}
];
export const events = [
  {id:'e1',title:'SIRE 2.0 Evidence Workshop',date:'06 Sep 2026',time:'18:30 IST',type:'Workshop',speaker:'Capt. Elena Fernandez',attendees:618,mode:'Live online',description:'Bring one real inspection question and learn how to build a strong evidence-based response.'},
  {id:'e2',title:'Sea to Shore: Superintendent Career Night',date:'12 Sep 2026',time:'19:00 IST',type:'Networking Event',speaker:'3 Fleet Managers + 2 Recruiters',attendees:884,mode:'Live online',description:'A practical networking session for senior officers planning shore careers.'},
  {id:'e3',title:'Maritime AI Forum 2026',date:'27 Sep 2026',time:'11:00 IST',type:'Conference',speaker:'Operators · Founders · Class',attendees:1240,mode:'Mumbai',description:'Practical AI applications in shipping, training, operations and maritime safety.'}
];
export const articles = [
  {id:'a1',type:'Regulation',title:'What senior officers should track in the next wave of emissions compliance',source:'Sea N Shore Knowledge Desk',read:'7 min',discussions:86,summary:'A practical map of how operational data, SEEMP discipline and performance conversations are changing onboard responsibilities.'},
  {id:'a2',type:'Safety Alert',title:'Near-miss learning: when checklist compliance masks weak situational awareness',source:'Safety Learning Network',read:'5 min',discussions:112,summary:'Why teams can complete every box and still miss the developing risk—and how leaders can test real understanding.'},
  {id:'a3',type:'Industry',title:'The new shore-career premium: professionals who translate sea experience into data and decisions',source:'Sea N Shore Editorial',read:'6 min',discussions:73,summary:'Operations teams increasingly value maritime judgement combined with analytics, communication and commercial awareness.'}
];
export const adminMetrics = [
  ['Total professionals','38,420','+8.4%'],['Monthly active','21,860','+11.2%'],['Job applications','12,940','+16.7%'],['Course enrollments','6,480','+13.1%'],['Pending verifications','186','Action'],['MRR run-rate','₹18.6L','+9.6%']
] as const;
