using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Charamaker2;
using Charamaker2.Character;
using Charamaker2.input;
using Charamaker2.Shapes;
using GameSet1;
using THE_Tournament.wepon;

namespace THE_Tournament.relic
{
    abstract class Relic
    {
       protected player p = null;
        protected static float size = 32;
        
        character _c;

        public character c { get{ return _c; } }
        public Relic(character c)
        {
            this._c = c;
        }
        public Relic(float size)
        {
            this._c = character.onepicturechara("relics\\" + this.GetType().Name,size);
        }
        virtual public character getc() { return new character(_c); }

        virtual public string getname(params float[] fts) { return FP.GT("RN"+this.GetType().Name,null,fts); }
        virtual public string getsetumei(params float[] fts) { return FP.GT("RS"+this.GetType().Name, null, fts); }

       

        public virtual bool add(player p)
        {
            if (this.p == null)
            {
                var res = getsame(p);
               // Console.WriteLine(this.GetType() + "  " + res.Count);
                if (res.Count==0) 
                {
                    if (this.p == null && p.addRelic(this))
                    {
                        this.p = p;
                        onadd();
                        return true;
                    }

                    return false;
                }
                else
                {
                    this.p = p;

                    kasane(res.First());
                    return true;
                }
            }
            return false;
        }
        virtual protected List<Relic> getsame(player p)
        {
            var res = new List<Relic>();
            foreach (var a in p.relics)
            {
                if (a.GetType() == this.GetType() )
                {
                    res.Add(a);
                }
            }
            return res;
        }
        protected abstract void kasane(Relic r);

        virtual protected void onadd()
        {

        }
        virtual public bool remove()
        {
            if (p != null&&p.removeRelic(this))
            {
                onremove();
                p = null;
                return true;
            }

            return false;
        }

        virtual protected void onremove()
        {

        }
        virtual public void UIn(int cou,inputin i, hyojiman h, float cl) 
        {
            c.frame(cl);
            var eff=new effectchara(h, cl, this._c);
           
            eff.addmotion(new zchangeman(cl, "", 9999999999));

            float size =  h.ww / 10 ;
            
            eff.scalechange(size / (Math.Abs(eff.w) + Math.Abs(eff.h)), true);
            
            eff.setcxy(h.camx + cou * eff.w+eff.w/2, h.camy + eff.h / 2, +eff.w / 2, +eff.h / 2);
            var rec = new Rectangle(0,0);
            rec.setto(eff);
         
            if (rec.onhani(i.x, i.y))
            {
                float si = h.ww * 0.02f;

                message.hutidorin(si/15,h.camx,h.camy+eff.h*1.2f,si,(int)(h.ww/si*2),0,0,0,getname()+"\n"+getsetumei(),hyo:h);
            }
        }
        public string save()
        {
            string res = "";
            res += this.GetType().ToString() + "=";
            res += this.saveman();
            return res;
        }
        protected abstract string saveman();

        public static Relic loadman(string hukug) { return null; }

        public static Relic load(string saves)
        {
            var aas = saves.Split('=');
            var mes = Type.GetType(aas[0]).GetMethod("loadman");
            var hiki = new object[] { aas[1] };
            var rel=(Relic)mes.Invoke(aas, hiki);

            return rel;
        }
    }
    abstract class oneatskrelic : Relic
    {

        public oneatskrelic() : base(size)
        {

        }
        protected override void onadd()
        {
            base.onadd();
            p.EEV.added += waaa;
            p.EEV.removed += wooo;
            p.EEV.dodamage += hit;
            p.EEV.damaged += hitted;

        }
        private void sentitymaked(object sender, SEEventArgs se)
        {
            if (filter(se.sent))
            {
                se.sent.EEV.dodamage += hit;
                se.sent.EEV.damaged += hitted;
            }
        }
        private void hit(object sender, SEEventArgs e)
        {
            if (ok(e.sent) && cou > 0 && p.EM.istyped(typeof(player), e.tag))
            {
                for (int i = 0; i < eikyocount(e.sent); i++)
                {
                    cou -= 1;
                    hitmotion();

                    eikyo((player)e.tag);
                }
            }
        }
        private void hitted(object sender, SEEventArgs e)
        {
            if (ok(e.stag) && cou > 0 && p.EM.istyped(typeof(player), e.ent))
            {
                for (int i = 0; i < eikyocount(e.sent); i++)
                {
                    cou -= 1;
                    hitmotion();
                    eikyo((player)e.ent);
                }

            }
        }
      

        public override string getname(params float[] fts)
        {
            return base.getname(cou, max);
        }
    
        virtual protected void hitmotion()
        {
            c.addmotion(new idouman(60, 0, 0, 6));
        }
        abstract protected void eikyo(player tag);
        virtual protected List<weponslot> filter(List<weponslot> w)
        {
            for (int i = w.Count - 1; i >= 0; i--)
            {
                if (w[i].wep == null) w.RemoveAt(i);
            }
            return w;
        }
        abstract protected bool filter(Sentity s);

        abstract protected int maxcount(Wepon w);
        abstract protected int eikyocount(Sentity e);

        abstract protected bool ok(Sentity s);
        protected override void onremove()
        {
            base.onremove();

            p.EEV.added -= waaa;
            p.EEV.removed -= wooo;
            p.EEV.dodamage -= hit;
            p.EEV.damaged -= hitted;
        }
        private void waaa(object sender, EEventArgs e)
        {
            max = 0;
            cou = 0;
            foreach (var a in filter(new List<weponslot>(((player)sender).WS)))
            {
                if (a.wep != null)
                {
                    max += maxcount(a.wep);
                    a.wep.EEV.attack += chance;
                    a.wep.EEV.skill += chance;
                    a.wep.EEV.Sentitymake += sentitymaked;
                }
            }
        }
        private void wooo(object sender, EEventArgs e)
        {
            max = 0;
            cou = 0;
            foreach (var a in (new List<weponslot>(((player)sender).WS)))
            {
                if (a.wep != null)
                {
                    a.wep.EEV.attack -= chance;
                    a.wep.EEV.skill -= chance;
                    a.wep.EEV.Sentitymake -= sentitymaked;
                }
            }
        }
        protected int max = 0;
        protected int cou = 0;
        private void chance(object sender, WEventArgs e)
        {
            if (cou < max)
            {
                cou += maxcount(e.w);
            }
        }
        private void chance(object sender, WskillEventArgs e)
        {
            if (cou < max)
            {
                cou += maxcount(e.w);
            }
        }
         public string save()
        {
            string res = "";
            res += this.GetType().ToString() + "=";
            res += saveman();
            return res;
        }
      
    }

    abstract class hitrelic : Relic
    {

        public hitrelic() : base(size)
        {

        }
        protected override void onadd()
        {
            base.onadd();
            p.EEV.added += waaa;
            p.EEV.removed += wooo;
            p.EEV.dodamage += hit;

        }
        virtual protected void sentitymaked(object sender, SEEventArgs se)
        {

            se.sent.EEV.dodamage += hit;
            se.sent.EEV.damaged += hitted;

        }
        abstract protected void hit(object sender, SEEventArgs e);
        abstract protected void hitted(object sender, SEEventArgs e);
        protected override void onremove()
        {
            base.onremove();

            p.EEV.added -= waaa;
            p.EEV.removed -= wooo;
            p.EEV.dodamage -= hit;
        }
        private void waaa(object sender, EEventArgs e)
        {
            foreach (var a in (new List<weponslot>(((player)sender).WS)))
            {
                if (a.wep != null)
                {
                    a.wep.EEV.Sentitymake += sentitymaked;
                }
            }
        }
        virtual protected void wooo(object sender, EEventArgs e)
        {

            foreach (var a in (new List<weponslot>(((player)sender).WS)))
            {
                if (a.wep != null)
                {
                    a.wep.EEV.Sentitymake -= sentitymaked;
                }
            }
        }
       
    }

}
