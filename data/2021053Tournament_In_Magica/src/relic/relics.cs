using Charamaker2;
using Charamaker2.Character;
using Charamaker2.input;
using GameSet1;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using THE_Tournament.waza;
using THE_Tournament.wepon;

namespace THE_Tournament.relic
{
    class soubihin : Relic 
    {
        //全てのレリックを圧縮可能にしなさい！！！
        public readonly string name;
        public PlayerStatus s;

        public soubihin(string nm,PlayerStatus henka):base(character.onepicturechara("relics\\" + nm, size))
        {
            name = nm;
            s = henka;
        }
        protected override void onadd()
        {
            p.s.influte(null,new PlayerStatus(s.hel,s.speed,s.dam,s.cool,s.skill,s.jizoku,s.size),true);
            base.onadd();
        }
    
        protected override void kasane(Relic r) 
        {
            p.s.influte(null, new PlayerStatus(s.hel, s.speed, s.dam, s.cool, s.skill, s.jizoku, s.size), true);
            ((soubihin)r).s.influte(null, s, true);
        }

        override protected List<Relic> getsame(player p)
        {

            var res = base.getsame(p);
            var rres = new List<Relic>();
            foreach (var a in res) 
            {
                if (((soubihin)a).name == this.name) 
                {
                    rres.Add(a);   
                }
            }
            return rres;
        }

        protected override void onremove()
        {
            p.s.influte(null, new PlayerStatus(-s.hel, -s.speed, -s.dam, -s.cool, -s.skill, -s.jizoku, -s.size), true);
            base.onremove();
        }
        public override string getname(params float[] fts)
        {
            return base.getname()+":"+FP.GT("RN"+name,null,fts);
        }
        public override string getsetumei(params float[] fts)
        {
            return base.getsetumei()+"\n"+FP.GT("RS" + name,null,fts)+"\n"+s.printstatus(false);
        }

        protected override string saveman()
        {
            return name+","+s.save();
        }
        public static new Relic loadman(string hukug) 
        {
            var aas=hukug.Split(',');
            var st = new PlayerStatus();
            st.load(aas[1]);
            st.start();
            return new soubihin(aas[0], st);

        }

    }
  
    class firesign : oneatskrelic 
    {
        float pow;
        float time;
        public firesign(float power,float time) : base() 
        {
            pow = power;
            this.time = time;
        }
        protected override List<weponslot> filter(List<weponslot> w)
        {
            base.filter(w);
            for (int i = w.Count - 1; i >= 0; i--) 
            {
                if (!w[i].wep.s.zokuseion(zokusei.fire))
                {
                    w.RemoveAt(i);
                }
            }
            return w;
        }
        protected override void kasane(Relic r)
        {
            ((firesign)r).pow += this.pow;
        }
        override protected List<Relic> getsame(player p)
        {

            var res = base.getsame(p);
            var rres = new List<Relic>();
            foreach (var a in res)
            {
                if (((firesign)a).time == this.time)
                {
                    rres.Add(a);
                }
            }
            return rres;
        }
        protected override bool filter(Sentity s)
        {
            return s.s.zokuseion(zokusei.fire);
        }
        protected override void eikyo(player tag)
        {
            new fired(pow/time,time).add(tag);
        }
        protected override bool ok(Sentity e)
        {
            return e.s.zokuseion(zokusei.fire);
        }
        protected override int maxcount(Wepon w)
        {
            return w.s.zokuseicou(zokusei.fire);
        }
        protected override int eikyocount(Sentity e)
        {
            return e.s.zokuseicou(zokusei.fire);
        }
        public override string getsetumei(params float[] fts)
        {
            return base.getsetumei(pow,time);
        }
        protected override string saveman()
        {
            return pow + "," + time;
        }
        public static new Relic loadman(string hukug)
        {
            var aas = hukug.Split(',');
            return new firesign(Convert.ToSingle(aas[0]), Convert.ToSingle(aas[1]));

        }
    }
    class icesign : oneatskrelic
    {
        float pow;
        float time;
        public icesign(float power, float time) : base()
        {
            pow = power;
            this.time = time;
        }
        protected override void kasane(Relic r)
        {
            ((icesign)r).pow += this.pow;
        }
        override protected List<Relic> getsame(player p)
        {

            var res = base.getsame(p);
            var rres = new List<Relic>();
            foreach (var a in res)
            {
                if (((icesign)a).time == this.time)
                {
                    rres.Add(a);
                }
            }
            return rres;
        }
        protected override List<weponslot> filter(List<weponslot> w)
        {
            base.filter(w);
            for (int i = w.Count - 1; i >= 0; i--)
            {
                if (!w[i].wep.s.zokuseion(zokusei.ice))
                {
                    w.RemoveAt(i);
                }
            }
            return w;
        }
        protected override bool filter(Sentity s)
        {
            return s.s.zokuseion(zokusei.ice);
        }
        protected override void eikyo(player tag)
        {
            new iced(pow , time).add(tag);
        }
        protected override bool ok(Sentity e)
        {
            return e.s.zokuseion(zokusei.ice);
        }
        protected override int maxcount(Wepon w)
        {
            return w.s.zokuseicou(zokusei.ice);
        }
        protected override int eikyocount(Sentity e)
        {
            return e.s.zokuseicou(zokusei.ice);
        }
        public override string getsetumei(params float[] fts)
        {
            return base.getsetumei(time,pow);
        }
        protected override string saveman()
        {
            return pow + "," + time;
        }
        public static new Relic loadman(string hukug)
        {
            var aas = hukug.Split(',');
            return new icesign(Convert.ToSingle(aas[0]), Convert.ToSingle(aas[1]));

        }
    }
    class windsign : oneatskrelic
    {
        float pow;
        float time;
        public windsign(float power, float time) : base()
        {
            pow = power;
            this.time = time;
        }
        protected override void kasane(Relic r)
        {
            ((windsign)r).pow += this.pow;
        }
        override protected List<Relic> getsame(player p)
        {

            var res = base.getsame(p);
            var rres = new List<Relic>();
            foreach (var a in res)
            {
                if (((windsign)a).time == this.time)
                {
                    rres.Add(a);
                }
            }
            return rres;
        }
        protected override List<weponslot> filter(List<weponslot> w)
        {
            base.filter(w);
            for (int i = w.Count - 1; i >= 0; i--)
            {
                if (!w[i].wep.s.zokuseion(zokusei.wind))
                {
                    w.RemoveAt(i);
                }
            }
            return w;
        }
        protected override bool filter(Sentity s)
        {
            return s.s.zokuseion(zokusei.wind);
        }
        protected override void eikyo(player tag)
        {
            new winded(pow, time).add(tag);
        }

        protected override bool ok(Sentity e)
        {
            return e.s.zokuseion(zokusei.wind);
        }
        protected override int maxcount(Wepon w)
        {
            return w.s.zokuseicou(zokusei.wind);
        }
        protected override int eikyocount(Sentity e)
        {
            return e.s.zokuseicou(zokusei.wind);
        }
        public override string getsetumei(params float[] fts)
        {
            return base.getsetumei(time,pow);
        }
        protected override string saveman()
        {
            return pow + "," + time;
        }
        public static new Relic loadman(string hukug)
        {
            var aas = hukug.Split(',');
            return new windsign(Convert.ToSingle(aas[0]), Convert.ToSingle(aas[1]));

        }
    }
    class earthsign : oneatskrelic
    {
        float pow;
        float time;
        public earthsign(float power, float time) : base()
        {
            pow = power;
            this.time = time;
        }


        protected override void kasane(Relic r)
        {
            ((earthsign)r).pow += this.pow;
        }
        override protected List<Relic> getsame(player p)
        {

            var res = base.getsame(p);
            var rres = new List<Relic>();
            foreach (var a in res)
            {
                if (((earthsign)a).time == this.time)
                {
                    rres.Add(a);
                }
            }
            return rres;
        }
        protected override List<weponslot> filter(List<weponslot> w)
        {
            base.filter(w);
            for (int i = w.Count - 1; i >= 0; i--)
            {
                if (!w[i].wep.s.zokuseion(zokusei.earth))
                {
                    w.RemoveAt(i);
                }
            }
            return w;
        }
        protected override bool filter(Sentity s)
        {
            return s.s.zokuseion(zokusei.earth);
        }
        protected override void eikyo(player tag)
        {
            new earthed(pow, time).add(tag);
        }

        protected override bool ok(Sentity e)
        {
            return e.s.zokuseion(zokusei.earth);
        }
        protected override int maxcount(Wepon w)
        {
            return w.s.zokuseicou(zokusei.earth);
        }
        protected override int eikyocount(Sentity e)
        {
            return e.s.zokuseicou(zokusei.earth);
        }
        public override string getsetumei(params float[] fts)
        {
            return base.getsetumei(time,pow);
        }
        protected override string saveman()
        {
            return pow + "," + time;
        }
        public static new Relic loadman(string hukug)
        {
            var aas = hukug.Split(',');
            return new earthsign(Convert.ToSingle(aas[0]), Convert.ToSingle(aas[1]));

        }
    }
    class thundersign : oneatskrelic
    {
        float pow;
        float time;
        public thundersign(float power, float time) : base()
        {
            pow = power;
            this.time = time;
        }

        protected override void kasane(Relic r)
        {
            ((thundersign)r).pow += this.pow;
        }
        override protected List<Relic> getsame(player p)
        {

            var res = base.getsame(p);
            var rres = new List<Relic>();
            foreach (var a in res)
            {
                if (((thundersign)a).time == this.time)
                {
                    rres.Add(a);
                }
            }
            return rres;
        }
        protected override List<weponslot> filter(List<weponslot> w)
        {
            base.filter(w);
            for (int i = w.Count - 1; i >= 0; i--)
            {
                if (!w[i].wep.s.zokuseion(zokusei.thunder))
                {
                    w.RemoveAt(i);
                }
            }
            return w;
        }
        protected override bool filter(Sentity s)
        {
            return s.s.zokuseion(zokusei.thunder);
        }
        protected override void eikyo(player tag)
        {
            new thundered(pow, time).add(tag);
        }

        protected override bool ok(Sentity e)
        {
            return e.s.zokuseion(zokusei.thunder);
        }
        protected override int maxcount(Wepon w)
        {
            return w.s.zokuseicou(zokusei.thunder);
        }
        protected override int eikyocount(Sentity e)
        {
            return e.s.zokuseicou(zokusei.thunder);
        }
        public override string getsetumei(params float[] fts)
        {
            return base.getsetumei(time,pow);
        }
        protected override string saveman()
        {
            return pow + "," + time;
        }
        public static new Relic loadman(string hukug)
        {
            var aas = hukug.Split(',');
            return new thundersign(Convert.ToSingle(aas[0]), Convert.ToSingle(aas[1]));

        }
    }
    class lightsign : oneatskrelic
    {
        float pow;
        float time;
        public lightsign(float power, float time) : base()
        {
            pow = power;
            this.time = time;
        }

        protected override void kasane(Relic r)
        {
            ((lightsign)r).pow += this.pow;
        }
        override protected List<Relic> getsame(player p)
        {

            var res = base.getsame(p);
            var rres = new List<Relic>();
            foreach (var a in res)
            {
                if (((lightsign)a).time == this.time)
                {
                    rres.Add(a);
                }
            }
            return rres;
        }
        protected override List<weponslot> filter(List<weponslot> w)
        {
            base.filter(w);
            for (int i = w.Count - 1; i >= 0; i--)
            {
                if (!w[i].wep.s.zokuseion(zokusei.light))
                {
                    w.RemoveAt(i);
                }
            }
            return w;
        }
        protected override bool filter(Sentity s)
        {
            return s.s.zokuseion(zokusei.light);
        }
        protected override void eikyo(player tag)
        {
            new lighted(pow, time).add(tag);
        }

        protected override bool ok(Sentity e)
        {
            return e.s.zokuseion(zokusei.light);
        }
        protected override int maxcount(Wepon w)
        {
            return w.s.zokuseicou(zokusei.light);
        }
        protected override int eikyocount(Sentity e)
        {
            return e.s.zokuseicou(zokusei.light);
        }
        public override string getsetumei(params float[] fts)
        {
            return base.getsetumei(time,pow);
        }
        protected override string saveman()
        {
            return pow + "," + time;
        }
        public static new Relic loadman(string hukug)
        {
            var aas = hukug.Split(',');
            return new lightsign(Convert.ToSingle(aas[0]), Convert.ToSingle(aas[1]));

        }
    }
    class darksign : oneatskrelic
    {
        float pow;
        float time;
        public darksign(float power, float time) : base()
        {
            pow = power;
            this.time = time;
        }

        protected override void kasane(Relic r)
        {
            ((darksign)r).pow += this.pow;
        }
        override protected List<Relic> getsame(player p)
        {

            var res = base.getsame(p);
            var rres = new List<Relic>();
            foreach (var a in res)
            {
                if (((darksign)a).time == this.time)
                {
                    rres.Add(a);
                }
            }
            return rres;
        }
        protected override List<weponslot> filter(List<weponslot> w)
        {
            base.filter(w);
            for (int i = w.Count - 1; i >= 0; i--)
            {
                if (!w[i].wep.s.zokuseion(zokusei.dark))
                {
                    w.RemoveAt(i);
                }
            }
            return w;
        }
        protected override bool filter(Sentity s)
        {
            return s.s.zokuseion(zokusei.dark);
        }
        protected override void eikyo(player tag)
        {
            new darked(pow, time).add(tag);
        }

        protected override bool ok(Sentity e)
        {
            return e.s.zokuseion(zokusei.dark);
        }
        protected override int maxcount(Wepon w)
        {
            return w.s.zokuseicou(zokusei.dark);
        }
        protected override int eikyocount(Sentity e)
        {
            return e.s.zokuseicou(zokusei.dark);
        }
        public override string getsetumei(params float[] fts)
        {
            return base.getsetumei(time,pow);
        }
        protected override string saveman()
        {
            return pow + "," + time;
        }
        public static new Relic loadman(string hukug)
        {
            var aas = hukug.Split(',');
            return new darksign(Convert.ToSingle(aas[0]), Convert.ToSingle(aas[1]));

        }
    }
    class SoUnd : hitrelic 
    {
        float per;
        public SoUnd(float percentage) : base() 
        {
            per = percentage;
        }
        

        protected override void kasane(Relic r)
        {
            ((SoUnd)r).per += this.per;
        }
        protected override void hit(object sender, SEEventArgs e)
        {
            p.s.influte(null, new status(-e.s.hel * per, null));
        }

        protected override void hitted(object sender, SEEventArgs e)
        {
            if(e.stag.s.ataritti(e.s)&&e.sent!=null)
            p.s.influte(null, new status(-e.s.hel * per, null));
        }
        public override string getsetumei(params float[] fts)
        {
            return base.getsetumei((float)Math.Round(per * 100, 2));
        }
        protected override void onadd()
        {
            base.onadd();
            c.resettokijyun();
            c.resetmotion();
            c.addmotion(new idouman(1, 0, 0, -33));
            var m = new motion();
            m.sp = 0.75f;
            for (int i = 0; i < 6; i++)
            {
                m.addmoves(new idouman(2, 0, 0, 6+i,true));
            }
            for (int i = 0; i < 6; i++)
            {
                m.addmoves(new idouman(2, 0, 0, - i, true));
            }
            for (int i = 0; i < 6; i++)
            {
                m.addmoves(new idouman(2, 0, 0, -6 - i, true));
            }
            for (int i = 0; i < 6; i++)
            {
                m.addmoves(new idouman(2, 0, 0,  + i, true));
            }
            m.loop=true;

            c.addmotion(m);
        }
        protected override string saveman()
        {
            return per+",";
        }
        public static new Relic loadman(string hukug)
        {
            var aas = hukug.Split(',');
            return new SoUnd(Convert.ToSingle(aas[0]));

        }
    }
    class unmatch : Relic 
    {
        int n=1;
        public unmatch(int kai):base(size) 
        {
            n = kai;
        }

        protected override void kasane(Relic r)
        {
            ((unmatch)r).n += n;
        }
        protected override void onremove()
        {
            base.onremove();
            p.EEV.added -= go;
            p.EEV.removed -= goout;
        }

        protected override void onadd()
        {
            base.onadd();
            p.EEV.added += go;
            p.EEV.removed += goout;
            zz.Clear();
        }
        List<zokusei> zz = new List<zokusei>();
        private void skilled(object sender, WskillEventArgs e) 
        {
            bool hatua = false;
            if (e.w.s.zokuseion(zokusei.fire)) 
            {
                if (zz.Contains(zokusei.ice))
                {
                    hatua = true;
                    zz.Add(zokusei.fire);

                }
                else 
                {
                    zz.Add(zokusei.fire);
                }   
            }
            if (e.w.s.zokuseion(zokusei.ice))
            {
                if (zz.Contains(zokusei.fire))
                {
                    hatua = true;
                    zz.Add(zokusei.ice);

                }
                else
                {
                    zz.Add(zokusei.ice);
                }
            }

            if (e.w.s.zokuseion(zokusei.light))
            {
                if (zz.Contains(zokusei.dark))
                {
                    hatua = true;
                    zz.Add(zokusei.light);

                }
                else
                {
                    zz.Add(zokusei.light);
                }
            }
            if (e.w.s.zokuseion(zokusei.dark))
            {
                if (zz.Contains(zokusei.light))
                {
                    hatua = true;
                    zz.Add(zokusei.dark);
                }
                else
                {
                    zz.Add(zokusei.dark);
                }
            }

            if (e.w.s.zokuseion(zokusei.earth))
            {
                if (zz.Contains(zokusei.thunder)&& zz.Contains(zokusei.wind))
                {
                    hatua = true;
                    zz.Add(zokusei.earth);
                }
                else
                {
                    zz.Add(zokusei.earth);
                }
            }
            if (e.w.s.zokuseion(zokusei.thunder))
            {
                if (zz.Contains(zokusei.earth) && zz.Contains(zokusei.wind))
                {
                    hatua = true;
                    zz.Add(zokusei.thunder);
                }
                else
                {
                    zz.Add(zokusei.thunder);
                }
            }
            if (e.w.s.zokuseion(zokusei.wind))
            {
                if (zz.Contains(zokusei.thunder) && zz.Contains(zokusei.earth))
                {
                    hatua = true;
                    zz.Add(zokusei.wind);
                }
                else 
                {
                    zz.Add(zokusei.wind);
                }
            }
            if (hatua)
            {
                if (zz.Contains(zokusei.fire) && zz.Contains(zokusei.ice)) 
                {
                    while (zz.Remove(zokusei.fire)) ;
                    while (zz.Remove(zokusei.ice)) ;
                }
                if (zz.Contains(zokusei.thunder) && zz.Contains(zokusei.earth)&& zz.Contains(zokusei.wind))
                {
                    while (zz.Remove(zokusei.wind)) ;
                    while (zz.Remove(zokusei.earth)) ;
                    while (zz.Remove(zokusei.thunder)) ;
                }
                if (zz.Contains(zokusei.dark) && zz.Contains(zokusei.light))
                {
                    while (zz.Remove(zokusei.dark)) ;
                    while (zz.Remove(zokusei.light)) ;
                }
                hatu(e.w);
            }
            {
                for (int i = zz.Count - 1; i >= 0; i--) 
                {
                    for (int t = i-1; t >= 0; t--) 
                    {
                        if (zz[i] == zz[t]) 
                        {
                            zz.RemoveAt(i);
                            break;
                        }
                    }
                }
            }
        }
        protected void hatu(Wepon w) 
        {
            p.hyoji.playoto("bite", 0.5f);
            var ww = new Waza(FP.PR("unmatch"));
            ww.framed += (a, b) => { w.s.attackhaste(b.cl * w.s.cool*n/ FP.PR("unmatch")); };
      //      Console.WriteLine("Say!!");
            ww.add(w);
            c.addmotion(new idouman(FP.PR("unmatch"), 0, 0, 6));
        }
        private void go(object sender, EEventArgs E) 
        {
    //        Console.WriteLine("SOYSOYS!!");
            foreach (var a in p.WS) 
            {
                if (a.wep != null) 
                {
                    a.wep.EEV.skill += skilled;
                }
            }
        }
        private void goout(object sender, EEventArgs E)
        {
         //   Console.WriteLine("APOSUISAOIFFA!!");
            foreach (var a in p.WS)
            {
                if (a.wep != null)
                {
                    a.wep.EEV.skill -= skilled;
                }
            }
        }
        public override string getsetumei(params float[] fts)
        {
            return base.getsetumei(n);
        }
        public override string getname(params float[] fts)
        {
            string add = " ";
            foreach (var a in zz) add += FP.GT("SN"+a.ToString());
            return base.getname(fts)+add;
        }
        protected override string saveman()
        {
            return n + "," ;
        }
        public static new Relic loadman(string hukug)
        {
            var aas = hukug.Split(',');
            return new unmatch(Convert.ToInt32(aas[0]));

        }
    }

}
