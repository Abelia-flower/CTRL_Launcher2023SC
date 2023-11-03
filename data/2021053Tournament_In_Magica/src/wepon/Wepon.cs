using Charamaker2;
using Charamaker2.Character;
using Charamaker2.input;
using Charamaker2.Shapes;
using GameSet1;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace THE_Tournament.wepon
{
    class weponslot
    {
        protected player _p;
        public player p { get { return _p; } }
        public float dx, dy, dz;
        protected Wepon _wep = null;

        public Wepon wep { get { return _wep; } }

        public weponslot(float dx, float dy, float dz)
        {
            this.dx = dx;
            this.dy = dy;
            this.dz = dz;
        }
        public void frame(float cl)
        {
            soroewep();
            wep?.frame(cl);

        }
        public virtual void input(inputin i, float cl) { }
        public void UIn(int cou,inputin i,hyojiman hyo, float cl)
        {

            wep?.UIn(cou,i,hyo, cl);

        }

        public void soroewep()
        {
            if (wep != null)
            {
                wep.c.mirror = p.c.mirror; 
                wep.c.addmotion(new Kzchangeman(wep.c.core.nm, wep.c.core.nm, dz, true));
                if (wep.c.mirror)
                {
                    wep.c.settxy(p.c.getcx((p.c.w-dx), dy), p.c.getcy((p.c.w - dx), dy));
                }
                else 
                {
                    wep.c.settxy(p.c.getcx(dx, dy), p.c.getcy(dx, dy));
                }
            }
        }

        public void onadd(EntityManager EM) 
        {
            soroewep();

            this.wep?.add(EM);
        }

        public bool weponset(Wepon w)
        {
            if (_wep == null)
            {
                _wep = w;
                return true;
            }
            return false;
        }
        public bool weponunset(Wepon w)
        {
            if (_wep != w)
            {
                return false;
            }
            _wep = null;

            return true;
        }

        public bool addweponslot(player p)
        {
            if (p.WS.Contains(this))
            {
                return false;
            }
            p.WS.Add(this);
            _p = p;
            return true;
        }
        public bool removeweponslot(player p)
        {
            if (p.WS.Remove(this))
            {
                _p = null;
                return true;
            }
            return false;
        }
        public void autoskill(player tag) 
        {
            wep?.autoskill(tag);
        }
    }

    class WEventArgs : EEventArgs
    {
        public Weponstatus s;
        public Wepon w { get { return (Wepon)ent; } set { ent = value; } }
        public Wepon wtag { get { return (Wepon)tag; } set { tag = value; } }
        public WEventArgs(Wepon t, Wepon tag, Weponstatus s, float cl = 1) : base(t, tag, cl)
        {
            this.s = s;
        }
        public Sentity sent { get { return (Sentity)ent; } set { ent = value; } }
        public Sentity stag { get { return (Sentity)tag; } set { tag = value; } }

    }
    class WskillEventArgs 
    {
        public inputin i;
        public Wepon w;
        public WskillEventArgs(Wepon t,inputin i) 
        {
            w = t;
            this.i = i;
        }
    }
    class WEventer : EEventer
    {
        public new Wepon e { get { return (Wepon)base.e; } }
        public WEventer(Wepon w) : base(w)
        {

        }

        public event EventHandler<EEventArgs> soubi;
        public event EventHandler<EEventArgs> unsoubi;

        public void soubied(player p)
        {
            soubi?.Invoke(e, new EEventArgs(e, p));
        }
        public void unsoubied(player p)
        {
            unsoubi?.Invoke(e, new EEventArgs(e, p));
        }

        public event EventHandler<WEventArgs> damchange;
        public event EventHandler<WEventArgs> sizechange;

        public event EventHandler<WEventArgs> jizokuchange;
        public event EventHandler<WEventArgs> coolchange;

        public void damchanged(object sender, Wepon sent, Weponstatus w)
        {
            damchange?.Invoke(sender, new WEventArgs(sent, e, w));
        }
        public void sizechanged(object sender, Wepon sent, Weponstatus w)
        {
            sizechange?.Invoke(sender, new WEventArgs(sent, e, w));
        }
        public void jizokuchanged(object sender, Wepon sent, Weponstatus w)
        {
            jizokuchange?.Invoke(sender, new WEventArgs(sent, e, w));
        }
        public void coolchanged(object sender, Wepon sent, Weponstatus w)
        {
            coolchange?.Invoke(sender, new WEventArgs(sent, e, w));
        }

        public event EventHandler<WEventArgs> Dodamchange;
        public event EventHandler<WEventArgs> Dosizechange;

        public event EventHandler<WEventArgs> Dojizokuchange;
        public event EventHandler<WEventArgs> Docoolchange;

        public event EventHandler<WEventArgs> attack;
        public event EventHandler<WskillEventArgs> skill;

       public  event EventHandler<SEEventArgs> Sentitymake;

        public void Dodamchanged(object sender, Wepon tag, Weponstatus w)
        {
            Dodamchange?.Invoke(sender, new WEventArgs(e, tag, w));
        }
        public void Dosizechanged(object sender, Wepon tag, Weponstatus w)
        {
            Dosizechange?.Invoke(sender, new WEventArgs(e, tag, w));
        }
        public void Dojizokuchanged(object sender, Wepon tag, Weponstatus w)
        {
            Dojizokuchange?.Invoke(sender, new WEventArgs(e, tag, w));
        }
        public void Docoolchanged(object sender, Wepon tag, Weponstatus w)
        {
            Docoolchange?.Invoke(sender, new WEventArgs(e, tag, w));
        }
        public void skilled(object sender,inputin i)
        {
            skill?.Invoke(sender, new WskillEventArgs(e,i));
        }

        public void attacked(object sender)
        {
            attack?.Invoke(sender, new WEventArgs(e, e, e.s));
        }


        public void Sentitymaked(object sender, Sentity s) 
        {
            Sentitymake?.Invoke(sender, new SEEventArgs(s, s, s.s));
        }


        public void influted<T>(Wepon sent, T s)
           where T : Weponstatus
        {

            {
                if (s.dam != 0)
                {
                    damchanged(sent, sent, s);
                }
                if (s.size != 0)
                {
                    sizechanged(sent, sent, s);
                }
                if (s.jizoku != 0)
                {
                    jizokuchanged(sent, sent, s);
                }
                if (s.cool != 0)
                {
                    coolchanged(sent, sent, s);
                }
            }
        }
        /// <summary>
        /// こいつが変更するときとかこう
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="tag"></param>
        /// <param name="s"></param>
        public void Doinfluted<T>(Wepon tag, T s)
           where T : Weponstatus
        {
            tag.s.influte(tag, s);
            {
                if (s.dam != 0)
                {
                    Dodamchanged(e, tag, s);
                }
                if (s.size != 0)
                {
                    Dosizechanged(e, tag, s);
                }
                if (s.jizoku != 0)
                {
                    Dojizokuchanged(e, tag, s);
                }
                if (s.cool != 0)
                {
                    Docoolchanged(e, tag, s);
                }
            }

        }
    }
    abstract class Wepon : Entity
    {
        public Wepon(Weponstatus s, character c, ABrecipie a, buturiinfo b) : base(c, a, b)
        {
            this.s = s;
            s.setwep(this);
        }
        public player p { get { if (ws != null) return ws.p; return null; } }
       protected weponslot ws = null;


        protected bool goskill = false;
        virtual public void UIn(int cou, inputin i,hyojiman h, float cl) 
        {
            var eff = new effectchara(h, cl, this._c);

            float si =  h.ww / (ws.p.WS.Count + 1) /2;
            eff.copykakudo(this.c.getkijyun());
            if (c.w >= c.h)
            {
            
                eff.scalechange(si / eff.w, true);
            }
            else
            {
                
                eff.scalechange(si / eff.h, true);
            }
          
            eff.addmotion(new zchangeman(cl, "", 99999999));
            eff.setcxy(h.camx + (cou+1) * hyoji.ww/(ws.p.WS.Count+1), h.camy+hyoji.wh*0.8f, eff.w/2, eff.h/2);
            var rec = new Rectangle(0, 0);
            rec.setto(eff);

            if ((rec.onhani(i.x, i.y)&&i.ok(MouseButtons.Left,itype.down))||i.ok(shortkey(cou),itype.down))
            {
                goskill = true; 
            }
            if (goskill) 
            {
                eff.setcxy(i.x, i.y,eff.w/2,eff.h/2);
            }
           if(goskill && (i.ok(MouseButtons.Left, itype.up) || i.ok(shortkey(cou), itype.down)))
            {
                goskill = false;
                if(p.onEM&&s.doskill())skill(i);
            }
            if (s.skillgage < 1)
            {
                eff.addmotion(new Kopaman(cl, "", s.skillgage * 0.5f + 0.3f));
            }
            else
            {
                eff.addmotion(new Kopaman(cl, "", 1));
                var back = new effectchara(h, cl, eff.getcx(eff.w/2,eff.h/2), eff.getcy(eff.w / 2, eff.h / 2), 0, 0, 0, 0, 0, new setu("core", 0, 0, new picture(0, 0, 99999998
                    , si*1.4f, si * 1.4f, si * 1.4f / 2, si * 1.4f / 2, Math.PI/4, false, 0.8f, "def", new Dictionary<string, string> { { "def", @"effects\soul" } })));
            }
        }

        protected float[] getstdneraixy(float vhiritu=10)
        {
            float x = c.gettx(), y = c.getty();
            foreach (var a in p.tag)
            {
                float hitritu = fileman.whrandhani(vhiritu*100) / 100f;
                hitritu = 0;
                x = a.c.gettx() + a.bif.vx * hitritu;
                y = a.c.getty() + a.bif.vy * hitritu;
                break;
            }
            return new[] { x, y };
        }

        protected Keys shortkey(int cou) 
        {
            switch (cou) 
            {
                case 0:
                    return Keys.Space;
                case 1:
                    return Keys.Q;
                case 2:
                    return Keys.W;
                case 3:
                    return Keys.E;
                case 4:
                    return Keys.R;
                case 5:
                    return Keys.D6;
                case 6:
                    return Keys.D7;
                case 7:
                    return Keys.D8;
                case 8:
                    return Keys.D9;
                case 9:
                    return Keys.D0;
                default:
                    return Keys.None;
            }
        }

        public new WEventer EEV { get { return (WEventer)_EEV; } }
        protected override void setEEventer()
        {
            _EEV = new WEventer(this);
        }

        public virtual bool soubi(player p)
        {
            var aan = p.soubi(this);
            if (aan != null)
            {
                ws = aan;
                onsoubi();
                return true;
            }
            return false;
        }
        public virtual bool unsoubi()
        {
            if (p != null)
            {
                var aan = p.unsoubi(this);
                if (aan == ws)
                {
                    onunsoubi();
                    ws = null;
                    
                    return true;
                }
            }
            return false;
        }

        protected float gethealth() 
        {
            var ss=s.Z;
            while (ss.Remove(zokusei.energy)) ;
            return ss.Count * FP.PR("weponhealth") * power;
            
        }

        virtual protected void onsoubi() 
        {
            EEV.soubied(p);
            p.s.influte(null, new status(gethealth()), true);
        }
        virtual protected void onunsoubi()
        {
            p.s.influte(null, new status(-gethealth()), true);
            EEV.unsoubied(p);
        }


        public readonly Weponstatus s;

        public override void frame(float cl)
        {
            base.frame(cl);
            if (s.attack(cl)) attack();
        }

        public virtual void input(inputin i, float cl) { }
        virtual protected void attack() 
        {
            EEV.attacked(this);
        }
        virtual public void autoskill(player tag) 
        {
            if (s.doskill())
            {
                float hiritu = fileman.whrandhani(1000) / 100f;
                var i = new inputin();
                i.x = tag.c.gettx() + tag.bif.vx * hiritu;
                i.y = tag.c.getty() + tag.bif.vy * hiritu;



                skill(i);
            }
        }
        virtual protected void skill(inputin i) 
        {
            EEV.skilled(this,i);
        }


        protected override void onAdd()
        {
            base.onAdd();
            
            s.start();
        }
        public float power = 1;
        public virtual string getname() 
        {
            return Math.Round(power, 2).ToString() + FP.GT("WN"+this.GetType().Name)+"+"+Math.Round(gethealth(),0).ToString();
        }
        public virtual string getsetumei()
        {
            return FP.GT("WS" + this.GetType().Name);
        }

        public string save() 
        {
            string res = "";
            res += this.GetType().ToString()+"="+this.power+"=";
            res += this.s.save();
            return res;
        }
        public static Wepon load(string saves) 
        {
            var aas=saves.Split('=');
            var ty = Type.GetType(aas[0]);
            if (ty != null)
            {
                var wep = (Wepon)Activator.CreateInstance(ty, new Weponstatus(0, 0, 0, 0, 0, new List<zokusei>()));
                wep.power = Convert.ToSingle(aas[1]);
                wep.s.load(aas[2]);
                return wep;
            }
            return null;
        }
    }
    class Weponstatus:zokuseiable
    {
        Wepon w = null;
        protected float timer = 0,skilltimer=0;


        public float Timer { get { return timer; } }
        public float SkillTimer { get { return skilltimer; }set { skilltimer = value; } }

        protected float _cool, _dam, _size, _jizoku, _skill;
        public float skillgage { get { return skilltimer/_skill; } }

        public float cool { get { return _cool; } }
        public float skill { get { return _skill; } }

        public float dam { get { return _dam; } }

        public float size { get { return _size; } }
        public float jizoku { get { return _jizoku; } }

        public float Tcool { get { return Math.Max(w.p.s.cool,0.25f); } }
        public float Tskill { get { return Math.Max(w.p.s.skill,0.25f); } }

        public float Tdam { get { if (w == null) return dam; return Math.Max(dam * w.p.s.dam, 0.25f); } }

        public float Tsize { get { if (w == null) return size; return Math.Max(size * w.p.s.size, 0.25f); } }
        public float Tjizoku { get { if (w == null) return jizoku; return Math.Max(jizoku * w.p.s.jizoku, 0.25f); } }

        protected readonly List<zokusei> z = new List<zokusei>();
        public List<zokusei> Z { get { return new List<zokusei>(z); } }
        public bool zokuseion(params zokusei[] Z)
        {
            List<zokusei> ZZ = new List<zokusei>(Z);
            foreach (var a in z)
            {
                for (int i = 0; i < ZZ.Count; i++)
                {
                    if (a == Z[i])
                    {
                        ZZ.RemoveAt(i);
                        break;
                    }
                }
            }
            return ZZ.Count == 0;
        }
        public int zokuseicou(zokusei z)
        {
            var res = 0;
            foreach (var a in Z) if (a == z) res++;
            return res;
        }

        public void setzokusei(List<zokusei>zz ) 
        {
            z.Clear();
            z.AddRange(zz);
        }
        static public Weponstatus WSFromParam(string param, List<zokusei> z = null,float cool=1,float dam=1,float size=1,float jizoku=1,float skill=1 )
        {
            return new Weponstatus(FP.PR(param, 0)*cool, FP.PR(param, 1)*dam, FP.PR(param, 2)*size, FP.PR(param, 3)*jizoku, FP.PR(param, 4)*skill, z);
        }

        public Weponstatus(float cool, float dam, float size, float jizoku,float skill, List<zokusei> Z)
        {
            _cool = cool;
            _dam = dam;
            _size = size;
            _jizoku = jizoku;
            _skill = skill;
            if (skill < 1) _skill = 1;
            if (Z == null)
            {
                z = new List<zokusei> { };
            }
            else
            {
                z = new List<zokusei>(Z);
            }
        }
        /// <summary>
        /// 軽々に呼び出してくれるな
        /// </summary>
        /// <param name="s"></param>
        public void setwep(Wepon s)
        {
            w = s;
        }
        public bool doskill() 
        {
           
            if (skill<=skilltimer) 
            {
               
                skilltimer = skill * (fileman.whrandhani(50) ) / 1000f; 
                return true;
            }
            return false;
        }
        public void attackhaste(float ti) 
        {
            
            timer -= ti;
           // haste += ti;
           // sum += ti;
        }
        public void skillhaste(float ti)
        {
            skilltimer += ti;
        }
     //   float sum=0,clock = 0,haste=0;
        public bool attack(float cl)
        {
            if (w != null)
            {
            //    clock += cl;
             //   sum += cl * Tcool;
                timer -= cl *Tcool;
                skilltimer += cl * Tskill;
            }
            else
            {
                timer -= cl;
                skilltimer += cl;
            }

            if (timer <= 0)
            {
             //   if (sum < cool * 0.5f)
            //    {
             ////       Console.WriteLine(cool + ":: " + Math.Round(sum, 2) + " :: " + Math.Round(clock, 2) + " :: " + Math.Round(haste, 2) + " asl;fjka;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            //    }
            //    sum = 0;haste = 0;clock = 0;
                timer += cool * (fileman.whrandhani(100) + 900) / 1000f;
                timer = Math.Max(timer, 0);
                return true;
            }
         

            return false;
        }
        public void start()
        {
            skilltimer = skill * (fileman.whrandhani(50)+900) / 1000f;
            timer = cool * (fileman.whrandhani(100)+900) / 1000f;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="mot">nullも可</param>
        /// <param name="s"></param>
        /// <param name="over"></param>
        virtual public void influte<T>(Wepon mot, T s)
            where T : Weponstatus
        {
            w?.EEV.influted<T>(mot, s);


            {
                _cool += s.cool;
            }
            {
                _size += s.Tsize;
            }
            {
                _jizoku += s.Tjizoku;
            }
            {
                _dam += s.Tdam;
            }
            {
                _skill += s.skill;
            }
        }
        virtual public string printstatus()
        {
            var res =
                   FP.GT("SNWdam") + ":" + Math.Round(_dam,0) 
                 + " " + FP.GT("SNWjizoku") + ":" + Math.Round(_jizoku,0) 
                 + " " + FP.GT("SNWsize") + ":" + Math.Round(_size,2) 
                 + " " + FP.GT("SNWcool") + ":" + Math.Round(_cool,0)
                 + " " + FP.GT("SNWskill") + ":" + Math.Round(_skill,0)
                     + " " + FP.GT("SNzokusei") + ":";
            foreach (var a in z)
            {
                res += FP.GT("SN" + a.ToString());
            }
            return res;
        }
        virtual public string save()
        {
            var res =
                   _dam
                 + ":" + _jizoku
                 + ":" + _size
                 + ":" + _cool
                 + ":" + _skill;
                 
            foreach (var a in z)
            {
                res += ":"+a.ToString();
            }
            return res;
        }
        virtual public void load(string a)
        {
            var aas=a.Split(':');

            this._dam = Convert.ToSingle(aas[0]);
            this._jizoku = Convert.ToSingle(aas[1]);
            this._size = Convert.ToSingle(aas[2]);
            this._cool = Convert.ToSingle(aas[3]);
            this._skill = Convert.ToSingle(aas[4]);
            this.z.Clear();
            for (int i=5;i<aas.Length;i++) 
            {
                if (aas[i] != "")
                {
                    this.z.Add((zokusei)Enum.Parse(typeof(zokusei), aas[i]));
                }
            }
        }

    }


}
