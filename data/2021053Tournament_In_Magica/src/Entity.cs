using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GameSet1;
using Charamaker2;
using Charamaker2.Character;
namespace THE_Tournament
{
    class SEEventArgs :EEventArgs
    {
        public status s;
        public SEEventArgs(Sentity e,Sentity tag,status s,float cl=1) :base(e,tag,cl) 
        {
            this.s = s;
        }
        public Sentity sent{ get { return (Sentity)ent; }set {ent= value; } }
        public Sentity stag { get { return (Sentity)tag; } set { tag = value; } }

    }
    class SEEventer :EEventer
    {
        public new Sentity e { get { return (Sentity)base.e; }set{ base.e = value; } }
        public SEEventer(Sentity s) : base(s) 
        {
            
        }

        public event EventHandler<SEEventArgs> dodamage;

        public event EventHandler<SEEventArgs> doheal;

        public event EventHandler<SEEventArgs> damaged;

        public event EventHandler<SEEventArgs> healed;

        protected void Dodamage(object sender,status s,Sentity tag) 
        {
            dodamage?.Invoke(sender,new SEEventArgs((Sentity)e,tag,s));
        }
        protected void Doheal(object sender, status s, Sentity tag)
        {
            doheal?.Invoke(sender, new SEEventArgs((Sentity)e, tag, s));
        }

        protected void Damaged(object sender, status s, Sentity moto)
        {
            e.tikudam(-s.hel);
            damaged?.Invoke(sender, new SEEventArgs((Sentity)moto, (Sentity)e, s));
            
        }
        protected void Healed(object sender, status s, Sentity moto)
        {
            healed?.Invoke(sender, new SEEventArgs((Sentity)moto, (Sentity)e, s));
        }
        virtual public void influted<T,E>(E sent,T s, bool over = false)
            where T : status  where E:Sentity
        {
            if (over)
            {

            }
            else 
            {
                if (s.hel < 0)
                {
                    Damaged(s, s, sent);
                }
                else if (s.hel > 0) 
                {
                    Healed(s, s, sent);
                }
            }
        }

        

        /// <summary>
        /// こいつが攻撃するときとかこう
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="tag"></param>
        /// <param name="s"></param>
        /// <param name="over"></param>
       virtual public void Doinfluted<T,E>(E tag, T s, bool over = false)
           where T : status where E:Sentity
        {
            if (tag.s.ataritti(s) )
            {
                tag.s.influte(tag, s, over);
                if (over)
                {

                }
                else
                {
                    if (s.mhel < 0)
                    {
                        Dodamage(s, s, tag);
                    }
                    else if (s.mhel > 0)
                    {
                        Doheal(s, s, tag);
                    }
                }
            }
            else 
            {
                s.sukatta();
            }
        }

    }
    class Sentity : Entity
    {
        public new SEEventer EEV{ get { return (SEEventer)_EEV; } }
        protected override void setEEventer()
        {
            _EEV = new SEEventer(this);
        }
        public status s { get { return _s; } }
        protected status _s;
        public Sentity(status s,character c,ABrecipie ab,buturiinfo bif) : base(c,ab,bif) 
        {
            this._s = s;
            s.setEventin(this);
        }
        public override void frame(float cl)
        {
            base.frame(cl);
            if (s != null && s.sini)
            {
                remove();
            }
            
                showdam(cl);
            
          
        }
        protected override void onAdd()
        {
            base.onAdd();
            s.start();
            tikud = 0;
            timed = 0;
        }
        private void showdam(float time) 
        {
            if(tikud>0) timed += time;
            if (timed > 3)
            {
                float si = 16;
                
                var mm = message.hutidorin(si * 0.05f, c.gettx(), c.getty(), si, 100, 0, 0, 60
                    , Math.Round(tikud).ToString(), scene.test.getcolR(bif), scene.test.getcolG(bif), scene.test.getcolB(bif), hyo: hyoji);
                foreach (var a in mm)
                {
                    a.setfadein(10);
                    a.setfadeout(50, 10);
                }
                tikud = 0;
                timed = 0;
            }
        }
        protected override void onRemove()
        {
            base.onRemove();
            showdam(10);
        }
        private float tikud = 0;
        private float timed = 0;
        public void tikudam(float dam) 
        {
            tikud += dam;
          
        }
    }
    enum zokusei
    {
        physical, fire,ice,wind,earth,thunder,light,dark,energy,debuff
    }

    interface zokuseiable 
    {
        List<zokusei> Z { get; }
        bool zokuseion(params zokusei[] Z);
        int zokuseicou(zokusei z);
        void setzokusei(List<zokusei> z);
    }

    class status:zokuseiable
    {
        protected List<Sentity> Eventin = new List<Sentity>();
        public bool sini { get { return _hel <= 0; } }
        protected float _mhel,_hel;

        public float mhel { get { return _mhel; } }
        public float hel { get { return _hel; } }

        public float helwari 
        {
            get 
            { 
                if (_mhel == 0) return 0;
                var res = _hel / _mhel;
                if (res < 0) return 0;
                return res; 
            }
        }

       protected readonly List<zokusei> z = new List<zokusei>();

        /// <summary>
        /// helwariとかM側が0だったりマイナスしたらイケナイ割り算の奴
        /// </summary>
        /// <param name="kodomo"></param>
        /// <param name="haha"></param>
        public static float wariwary(float kodomo,float haha) 
        {
            if (haha <= 0) return 0;
            return kodomo / haha;
        }

        public void sukatta() 
        {
            _hel = 0;

        }
        
        public bool ataritti(status korega)
        {
            return !zokuseion(zokusei.energy) ||
                    (
                        (zokuseion(zokusei.fire) && korega.zokuseion(zokusei.ice)) ||
                        (zokuseion(zokusei.ice) && korega.zokuseion(zokusei.fire)) ||
                        (zokuseion(zokusei.light) && korega.zokuseion(zokusei.dark)) ||
                        (zokuseion(zokusei.dark) && korega.zokuseion(zokusei.light)) ||
                        (zokuseion(zokusei.physical) && korega.zokuseion(zokusei.physical)) ||
                        (zokuseion(zokusei.thunder) && korega.zokuseion(zokusei.earth)) ||
                        (zokuseion(zokusei.wind) && korega.zokuseion(zokusei.thunder)) ||
                        (zokuseion(zokusei.earth) && korega.zokuseion(zokusei.wind))
                    );
        }

        public List<zokusei> Z { get { return new List<zokusei>(z); } }
        /// <summary>
        /// 軽々に呼び出してくれるな
        /// </summary>
        /// <param name="s"></param>
        public void setEventin(Sentity s) 
        {
            Eventin.Add(s);
        }

        public status(float health=1,List<zokusei>Z=null) 
        {
            _mhel=health;
            _hel = health;
            if (Z == null)
            {
                z = new List<zokusei> { };
            }
            else 
            {
                z = new List<zokusei>(Z);
            }
        }
        public status(status s) 
        {
            _mhel = s._mhel;
            _hel = s._hel;
            z = new List<zokusei>(s.z);
        }
        public void setzokusei(List<zokusei> zz)
        {
            z.Clear();
            z.AddRange(zz);
        }
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

       virtual public void start() 
        {
            _hel = _mhel;   
        }
        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="mot">nullも可</param>
        /// <param name="s"></param>
        /// <param name="over"></param>
        virtual public void influte<T>(Sentity mot,T s, bool over = false)
            where T : status
        {
            foreach (var a in Eventin) 
            {
           
                a.EEV.influted<T,Sentity>(mot, s, over);

            }

            if (over)
            {
                _mhel += s._hel;
                if (_mhel < _hel)
                { 

                    _hel += Math.Max(_mhel - _hel, s._hel);
                }
                if (_mhel < 0) 
                {
                    s._hel -= _mhel;
                }

            }
            else
            {
                _hel += s._hel; 
                if (_hel < 0)
                {
                    s._hel -= _hel;
                }
                if (_hel > _mhel)
                {
                    var sa = _mhel - _hel;
                    _hel = _mhel;
                    s._hel += sa;
                }
            }
        }
        virtual public string printstatus(bool nowmo=true,bool nakutomo=false)
        {
            var res = "";
            if (nowmo)
            {
              res+=  FP.GT("SNhel") + ":" + Math.Round(_hel).ToString() + "/" + Math.Round(_mhel).ToString() + " " ;
            }
            else 
            {
                res += FP.GT("SNhel") + ":" + Math.Round(_mhel).ToString() + " ";
            }
            if (z.Count > 0 || nakutomo)
            {
                res+= FP.GT("SNzokusei") + ":";
                foreach (var a in z)
                {
                    res += FP.GT("SN" + a.ToString());
                }
            }
            return res;
        }
        virtual public string save()
        {
            string res =_mhel.ToString();
            foreach (var a in z)
            {
                res += ":"+a.ToString()  ;
            }
            return res;
        }
        virtual public void load(string a)
        {
            var aas = a.Split(':');

            this._mhel = Convert.ToSingle(aas[0]);
           
            this.z.Clear();
            for (int i = 1; i < aas.Length; i++)
            {
                this.z.Add((zokusei)Enum.Parse(typeof(zokusei), aas[5]));
            }
        }
    }
}
