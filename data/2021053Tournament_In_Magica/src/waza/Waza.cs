using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Charamaker2;
using Charamaker2.Character;
using Charamaker2.Shapes;
using GameSet1;
namespace THE_Tournament.waza
{
    //ダメージを与える・ダメージを受けた。どう区別??
    class Swaza : Waza
    {
        public Swaza(float end) : base(end)
        {

        }
        public override bool add(Entity e)
        {
            if (e.GetType() == typeof(Sentity) || e.GetType().IsSubclassOf(typeof(Sentity)))
            {
                return base.add(e);
            }
            Console.WriteLine("Waza not Sentity!!!!Error!");
            return false;
        }

        public new Sentity e { get { return (Sentity)base.e; } }
        static public void zokuseifilter<T>(List<T>list,List<zokusei>z)
            where T:Sentity
        {
            var s = new status(1, z);
            for (int i = list.Count - 1; i >= 0; i--) 
            {
                if (!list[i].s.ataritti(s)) 
                {
                    list.RemoveAt(i);
                }
            }
        }
    }
    class jisatukun2 : Swaza
    {
        bool HO;
        float bkaku;
        float removeeff;
        public jisatukun2(float time, float basekaku = 471, bool hpopa = true,float remveff=15) : base(time)
        {
            bkaku = basekaku;
            HO = hpopa;
            removeeff = remveff;
        }
        protected override void onFrame(float cl)
        {
            base.onFrame(cl);
            if (bkaku != 471)
            {
                e.c.addmotion(new radtoman(cl, "", bkaku + (Math.Atan2(e.bif.vy, e.bif.vx)) / Math.PI * 180, 360));
            }
            if (HO && e.s.helwari>0)
            {
                e.c.addmotion(new Kopaman(cl, "", e.s.helwari));
            }
        }
        protected override void onRemove()
        {
            if (removeeff > 0)
            {
                new effectchara(e.hyoji, removeeff, e.c).addmotion(new Kopaman(15, "", 0));
            }
            e.remove();
            base.onRemove();
        }
    }
    /// <summary>
    ///  物理的に当たらない奴な
    /// </summary>
    abstract class Bulletwaza : Swaza
    {
        public Bulletwaza(Sentity se, float end) : base(end)
        {

            base.add(se);

        }
        public override bool add(Entity e)
        {
            Console.WriteLine("This Waza DOnt Need ADD");
            return false;
        }

        public new Sentity e { get { return (Sentity)base.e; } }
        public override void frame(float cl)
        {

            base.frame(cl);


        }
        protected override void onFrame(float cl)
        {
            base.onFrame(cl);

            var lis = EM.getTypeEnts<Sentity>();

            atypefilter(lis, e.bif);
            zokuseifilter(lis, e.s.Z);
            atarisfilter(lis);
            atafilter<Sentity>(lis, null, e, null);
            
            foreach (var a in lis)
            {
                dowhat(a);
            }


        }
        protected override void onRemove()
        {
            base.onRemove();
        }
        abstract protected void dowhat(Sentity se);
    }
    class danganka : Bulletwaza
    {
        public event EventHandler<SEEventArgs> hitted;
        List<string> oto = new List<string>();
        List<float> otovol = new List<float>();
        public void otoadd(string oto, float vol)
        {
            this.oto.Add(oto);
            otovol.Add(vol);
        }
        float wari, mwari, minwari;
        float atime = -1;

        public danganka(Sentity se, float end, string oto = "punch", float damwari = 1, float mdamwari = 1, float mindamwariai = 0, float atime = -1, float otovol = 1) : base(se, end)
        {
            otoadd(oto, otovol);
            wari = damwari;
            mwari = mdamwari;
            this.atime = atime;
            minwari = mindamwariai;
        }
        protected override void dowhat(Sentity se)
        {
            if (!e.s.sini)
            {
                float at;
                if (Math.Abs(-e.s.hel * wari) < Math.Abs(-e.s.mhel * minwari))
                {
                    at = -e.s.mhel * minwari;

                }
                else if (Math.Abs(-e.s.hel * wari) < Math.Abs(-e.s.mhel * mwari))
                {
                    at = -e.s.hel * wari;
                }
                else
                {
                    at = -e.s.mhel * mwari;
                }
                if (Math.Abs(at) > e.s.hel)
                {
                    if (at < 0)
                    {
                        at = -e.s.hel;
                    }
                    else
                    {
                        at = e.s.hel;
                    }
                }



                var sss = new status(at, e.s.Z);
                this.e.EEV.Doinfluted(se, sss, false);
                if (wari > 0)
                {
                    e.s.influte(null, sss, false);
                }
                else if (wari < 0)
                {
                    e.s.influte(null, new status(-sss.hel, sss.Z), false);
                }

                hitted?.Invoke(this, new SEEventArgs(e, se, sss));
                for (int i = 0; i < oto.Count; i++)
                {
                    hyoji.playoto(oto[i], otovol[i]);
                }

                if (atime < 0)
                {
                    atarisAdd(se, end);
                }
                else
                {
                    atarisAdd(se, atime);
                }


                //  Console.WriteLine(e.ab.getallatari()[0].gettx() + " :asfa: " + e.ab.getallatari()[0].getty());
                // Console.WriteLine(e.pab.getallatari()[0].gettx() + " :tacklepas: " + e.pab.getallatari()[0].getty());
            }
        }
    }

    abstract class oneSentWaza : Swaza
    {
        protected picture s;
        /// <summary>
        /// 生成された攻撃エネルギ！
        /// </summary>
        public Sentity tok;
        float kakut;
        public oneSentWaza(Sentity se, float kakutyo, float end, picture s, Shape ss, float hp, character c = null, ABrecipie rec = null, buturiinfo bif = null) : base(end)
        {
            kakut = kakutyo;
            this.s = s;
            if (c == null)
            {
                c = new character(0, 0, 0, 0, 0, 0, 0, new setu("core", 0, 0, new picture(0, 0, 0, 0, 0, 0, 0, 0, false, 0, "def", new Dictionary<string, string> { { "def", "nothing" } })));
            }
            if (rec == null)
            {
                rec = new ABrecipie(new List<string> { "core" }, new List<Shape> { ss.clone() });
            }
            if (bif == null)
            {
                bif = new buturiinfo(atag: new List<string>(se.bif.atag));
            }
            this.tok = new Sentity(new status(hp), c, rec, bif);

            base.add(tok);


            soroeru();

            tok.add(se.EM, false);


        }
        public override bool add(Entity e)
        {
            Console.WriteLine("This Waza DOnt Need ADD");
            return false;
        }
        void soroeru()
        {

            float w = s.w + kakut;
            float h = s.h + kakut;
            tok.c.w = w;
            tok.c.h = h;
            tok.c.tx = w / 2;
            tok.c.ty = h / 2;
            tok.c.RAD = s.RAD;
            tok.c.core.p.w = w;
            tok.c.core.p.h = h;
            tok.c.core.p.tx = w / 2;
            tok.c.core.p.ty = h / 2;
            tok.c.core.p.RAD = s.RAD;

            tok.c.settxy(s.getcx(s.w / 2, s.h / 2), s.getcy(s.w / 2, s.h / 2));

            tok.ab.frame();

        }
        public new Sentity e { get { return (Sentity)base.e; } }
        public override void frame(float cl)
        {
            soroeru();
            base.frame(cl);

            if (tok.s.sini) remove();

        }
        protected override void onFrame(float cl)
        {
            base.onFrame(cl);

            var lis = EM.getTypeEnts<Sentity>();

            atypefilter(lis, tok.bif);
            atarisfilter(lis);
            atafilter<Sentity>(lis, null, tok, null);

            foreach (var a in lis)
            {
                dowhat(a);
            }


        }
        protected override void onRemove()
        {
            base.onRemove();

            tok.remove();
        }
        abstract protected void dowhat(Sentity se);
    }

    class tackle : oneSentWaza
    {
        List<string> oto = new List<string>();
        List<float> otovol = new List<float>();
        public void otoadd(string oto, float vol)
        {
            this.oto.Add(oto);
            otovol.Add(vol);
        }

        List<zokusei> z;
        float wari, mwari, minwari;
        public event EventHandler<SEEventArgs> hitted;
        float atime = -1;
        public tackle(Sentity se, float dam, List<zokusei> Z, float time, string setuname, string oto = "punch", float wari = 1, float mwari = 1, float minwari = 0, float atime = -1, float otovol = 1) : base(se, 1, time, se.c.GetSetu(setuname).p, se.ab.getatari(setuname), dam)
        {
            z = Z;
            otoadd(oto, otovol);
            this.wari = wari;
            this.mwari = mwari;
            this.minwari = minwari;
            this.atime = atime;
        }
        public tackle(Sentity se, float dam, List<zokusei> Z, float time, string setuname, Shape sss, string oto = "punch", float wari = 1, float mwari = 1, float minwari = 0, float atime = -1, float otovol = 1) : base(se, 1, time, se.c.GetSetu(setuname).p, sss, dam)
        {
            z = Z;
            otoadd(oto, otovol);
            this.wari = wari;
            this.mwari = mwari;
            this.minwari = minwari;

            this.atime = atime;
        }
        public tackle(Sentity se, float dam, List<zokusei> Z, float time, character motc, string setuname, Shape sss, string oto = "punch", float wari = 1, float mwari = 1, float minwari = 0, float atime = -1, float otovol = 1) : base(se, 1, time, motc.GetSetu(setuname).p, sss, dam)
        {
            z = Z;
            otoadd(oto, otovol);
            this.wari = wari;
            this.mwari = mwari;
            this.minwari = minwari;

            this.atime = atime;
        }

        protected override void dowhat(Sentity se)
        {
            if (!tok.s.sini)
            {
                float at;
                if (Math.Abs(-tok.s.hel * wari) < Math.Abs(-tok.s.mhel * minwari))
                {
                    at = -tok.s.mhel * minwari;

                }
                else if (Math.Abs(-tok.s.hel * wari) < Math.Abs(-tok.s.mhel * mwari))
                {
                    at = -tok.s.hel * wari;
                }
                else
                {
                    at = -tok.s.mhel * mwari;
                }
                var sss = new status(at, z);

                //  Console.WriteLine(tok.s.hel + " asaasdadnal ");

                this.tok.EEV.Doinfluted(se, sss, false);
                if (wari > 0)
                {
                    tok.s.influte(null, sss, false);
                }
                else if (wari < 0)
                {
                    tok.s.influte(null, new status(-sss.hel, sss.Z), false);
                }
                hitted?.Invoke(this, new SEEventArgs(e, se, sss));
                if (sss.hel != 0)
                {
                    for (int i = 0; i < oto.Count; i++)
                    {
                        hyoji.playoto(oto[i], otovol[i]);
                    }
                }
                if (atime < 0)
                {
                    atarisAdd(se, end);
                }
                else
                {
                    atarisAdd(se, atime);
                }//  Console.WriteLine(se.s.hel + " asadnal ");
                 //   Console.WriteLine(tok.ab.getallatari()[0].gettx() + " :asfa: " + tok.ab.getallatari()[0].getty());
                 //    Console.WriteLine(tok.pab.getallatari()[0].gettx() + " :tacklepas: " + tok.pab.getallatari()[0].getty());
            }
        }
        public override void frame(float cl)
        {
            base.frame(cl);
            //  tok.ab.getallatari()[0].drawshape(hyoji, 1, 1, 1, 1, true);
            //  tok.pab.getallatari()[0].drawshape(hyoji, 1, 0, 0, 1, true);
        }

        protected override void onFrame(float cl)
        {
            base.onFrame(cl);

        }
    }
    class jump : Waza
    {
        Rectangle r = new Rectangle(0, 0);
        float sp, sp2;
        string oto;
        public jump(float sp, float sp2, string oto = "pyonko") : base(10)
        {
            this.oto = oto;
            this.sp = sp;
            this.sp2 = sp2;
        }
        protected override void onAdd()
        {
            base.onAdd();
            sett();
        }
        protected void sett()
        {
            var core = e.Acore;
            r.w = core.w * 1f;
            r.h = 2;
            r.rad = core.rad;
            r.settxy(core.getcx(core.w / 2, core.h), core.getcy(core.w / 2, core.h));
        }

        public override void frame(float cl)
        {
            base.frame(cl);

            // r.drawshape(hyoji, 1, 1, 1, 1, true);
        }

        protected override void onFrame(float cl)
        {
            base.onFrame(cl);
            sett();
            var lis = EM.atarerus;
            atypefilter(lis, e.bif);
            atafilter(lis, null, r, r);
            foreach (var a in lis)
            {
                e.bif.kasoku(sp * (float)Math.Sin(e.Acore.rad) + sp2 * (float)Math.Cos(e.Acore.rad)
                    , -sp * (float)Math.Cos(e.Acore.rad) + sp2 * (float)Math.Sin(e.Acore.rad));
                remove();
                hyoji.playoto(oto);
                break;
            }
        }
    }

    class Pwaza : Waza
    {
        public Pwaza(float end) : base(end)
        {

        }
        public override bool add(Entity e)
        {
            if (e.GetType() == typeof(player) || e.GetType().IsSubclassOf(typeof(player)))
            {
                return base.add(e);
            }
            Console.WriteLine("Waza not player!!!!Error!");
            return false;
        }

        public new player e { get { return (player)base.e; } }

    }

    abstract class debuff : Pwaza
    {
        protected character c;
        protected float sum;
        public debuff(character c, float power, float time) : base(time)
        {
            this.c = c;
            pows.Add(power);
            times.Add(time);
        }
        public override bool add(Entity e)
        {

            var lis = e.getwazalis(this.GetType());
            if (lis.Count == 0)
            {
                if (base.add(e))
                {

                    foreach (var a in pows)
                    {
                        hatu(a);
                    }
                    setend();
                    return true;
                }
            }
            else
            {

                ((debuff)lis[0]).koukaadd(this);
            }
            return false;
        }
        protected override void onAdd()
        {
            base.onAdd();
            c.resettokijyun();
            c.scalechange(e.c.w / c.w, true);
            c.resethyoji(EM.hyoji);
        }
        protected override void onRemove()
        {
            base.onAdd();
            c.sinu(EM.hyoji);
        }
        public override void frame(float cl)
        {
            base.frame(cl);
            framen(sum, cl);
            for (int i = pows.Count - 1; i >= 0; i--)
            {

                times[i] -= cl;
                if (times[i] <= 0)
                {
                    kie(pows[i]);
                    pows.RemoveAt(i);
                    times.RemoveAt(i);
                }
            }
        }
        /// <summary>
        /// これをframenで呼び出せ
        /// </summary>
        /// <param name="size"></param>
        /// <param name="opa"></param>
        protected void setc(float size, float opa)
        {

            var m = new motion();
            float sss = (e.c.w + e.c.h) / (c.getkijyun().w + c.getkijyun().h) * size;

            //  Console.WriteLine(sss + "waaaa");
            m.addmoves(new Kscalechangeman(1, "", sss, sss));
            m.addmoves(new Kzchangeman(c.core.nm, c.core.nm, e.c.core.p.z + 999));
            m.addmoves(new Kopaman(1, "", opa));
            m.start(c);
            m.frame(c, 10);

            c.settxy(e.c.gettx(), e.c.getty());
        }

        protected void hatu(float f)
        {
            sum += f;
            hatudou(f);
        }
        protected void kie(float f)
        {
            sum -= f;
            kieru(f);

        }
        abstract protected void hatudou(float f);
        abstract protected void kieru(float f);
        /// <summary>
        /// setc呼び出せ
        /// </summary>
        /// <param name="f"></param>
        /// <param name="cl"></param>
        abstract protected void framen(float f, float cl);



        protected List<float> pows = new List<float>();
        protected List<float> times = new List<float>();

        protected void setend()
        {
            this.timer = 0;
            this.end = 0;
            for (int i = 0; i < pows.Count; i++)
            {
                if (end < times[i])
                {
                    end = times[i];
                }
            }

        }

        public void koukaadd(debuff d)
        {
            for (int i = 0; i < d.pows.Count; i++)
            {
                pows.Add(d.pows[i]);
                times.Add(d.times[i]);

                if (d.times[i] > this.nokori)
                {
                    timer = 0;
                    end = d.times[i];

                }
                hatu(d.pows[i]);
            }

        }

    }
    class fired : debuff
    {
        public fired(float power, float time) : base(character.onepicturechara("effects\\fired", 32, 999), power, time)
        {
        }
        protected override void framen(float f, float cl)
        {

            float summ = 0;
            for (int i = 0; i < pows.Count; i++)
            {
                summ += pows[i] * times[i];
            }
            setc(status.wariwary(summ, e.s.mhel) * 20 + 0.5f, status.wariwary(summ, e.s.mhel) * 10 * 0.4f + 0.4f);
            e.s.influte(null, new status(-f * cl, new List<zokusei> { zokusei.fire, zokusei.debuff }));
        }
        protected override void hatudou(float f)
        {
            return;
        }
        protected override void kieru(float f)
        {
            return;
        }
    }
    class iced : debuff
    {
        public iced(float power, float time) : base(character.onepicturechara("effects\\iced", 32, 999), power, time)
        {
        }
        protected override void framen(float f, float cl)
        {
            //    Console.WriteLine(pows.Count+"iceeeee"+sum);
            setc(status.wariwary(sum, e.s.mspeed) * 5 + 0.5f, status.wariwary(sum, e.s.mspeed) * 0.4f + 0.4f);
        }
        protected override void hatudou(float f)
        {
            e.s.influte(null, new PlayerStatus(0, -f, 0, 0, 0, 0, 0, new List<zokusei> { zokusei.ice, zokusei.debuff }));
            return;
        }
        protected override void kieru(float f)
        {
            e.s.influte(null, new PlayerStatus(0, f, 0, 0, 0, 0, 0, new List<zokusei> { zokusei.ice, zokusei.debuff }));
            return;
        }
    }
    class winded : debuff
    {
        public winded(float power, float time) : base(character.onepicturechara("effects\\winded", 32, 999), power, time)
        {
        }
        protected override void framen(float f, float cl)
        {

            setc(status.wariwary(sum, e.s.mspeed) * 10 + 0.5f, status.wariwary(sum, e.s.mspeed) * 0.4f + 0.4f);
        }
        protected override void hatudou(float f)
        {
            e.s.influte(null, new PlayerStatus(0, 0, 0, -f, 0, 0, 0, new List<zokusei> { zokusei.wind, zokusei.debuff }));
            return;
        }
        protected override void kieru(float f)
        {
            e.s.influte(null, new PlayerStatus(0, 0, 0, f, 0, 0, 0, new List<zokusei> { zokusei.wind, zokusei.debuff }));
            return;
        }
    }
    class earthed : debuff
    {
        public earthed(float power, float time) : base(character.onepicturechara("effects\\earthed", 32, 999), power, time)
        {
        }
        protected override void framen(float f, float cl)
        {

            setc(status.wariwary(sum, e.s.mspeed) * 5 + 0.5f, status.wariwary(sum, e.s.mspeed) * 0.4f + 0.4f);
        }
        protected override void hatudou(float f)
        {
            e.s.influte(null, new PlayerStatus(0, 0, 0, 0, 0, -f, 0, new List<zokusei> { zokusei.earth, zokusei.debuff }));
            return;
        }
        protected override void kieru(float f)
        {
            e.s.influte(null, new PlayerStatus(0, 0, 0, 0, 0, f, 0, new List<zokusei> { zokusei.earth, zokusei.debuff }));
            return;
        }
    }
    class thundered : debuff
    {
        public thundered(float power, float time) : base(character.onepicturechara("effects\\thundered", 32, 999), power, time)
        {
        }
        protected override void framen(float f, float cl)
        {

            setc(status.wariwary(sum, e.s.mspeed) * 5 + 0.5f, status.wariwary(sum, e.s.mspeed) * 0.4f + 0.4f);
        }
        protected override void hatudou(float f)
        {
            e.s.influte(null, new PlayerStatus(0, 0, -f, 0, 0, 0, 0, new List<zokusei> { zokusei.thunder, zokusei.debuff }));
            return;
        }
        protected override void kieru(float f)
        {
            e.s.influte(null, new PlayerStatus(0, 0, f, 0, 0, 0, 0, new List<zokusei> { zokusei.thunder, zokusei.debuff }));
            return;
        }
    }
    class lighted : debuff
    {
        public lighted(float power, float time) : base(character.onepicturechara("effects\\lighted", 32, 999), power, time)
        {
        }
        protected override void framen(float f, float cl)
        {

            setc(status.wariwary(sum, e.s.mspeed) * 5 + 0.5f, status.wariwary(sum, e.s.mspeed) * 0.4f + 0.4f);
        }
        protected override void hatudou(float f)
        {
            e.s.influte(null, new PlayerStatus(0, 0, 0, 0, -f, 0, 0, new List<zokusei> { zokusei.light, zokusei.debuff }));
            return;
        }
        protected override void kieru(float f)
        {
            e.s.influte(null, new PlayerStatus(0, 0, 0, 0, f, 0, 0, new List<zokusei> { zokusei.light, zokusei.debuff }));
            return;
        }
    }
    class darked : debuff
    {
        public darked(float power, float time) : base(character.onepicturechara("effects\\darked", 32, 999), power, time)
        {
        }
        protected override void framen(float f, float cl)
        {

            setc(status.wariwary(sum, e.s.mspeed) * 5 + 0.5f, status.wariwary(sum, e.s.mspeed) * 0.4f + 0.4f);
        }
        protected override void hatudou(float f)
        {
            e.s.influte(null, new PlayerStatus(0, 0, 0, 0, 0, 0, -f, new List<zokusei> { zokusei.dark, zokusei.debuff }));
            return;
        }
        protected override void kieru(float f)
        {
            e.s.influte(null, new PlayerStatus(0, 0, 0, 0, 0, 0, f, new List<zokusei> { zokusei.dark, zokusei.debuff }));
            return;
        }
    }
    class kisekinokosi:Waza
    {
        protected List<string> texs;
        
        protected float maxkanka,minkanka,minjizo,maxjizo,minkosu,maxkosu,minsize,maxsize,sokubai,z,kaiten;
        public kisekinokosi(float time, List<string> texs, float z, float maxkanka, float minkanka, float minjizo, float maxjizo
            , float minkosu, float maxkosu, float minsize, float maxsize, float sokubai, float kaiten=471) : base(time) 
        {
            this.texs = texs;
            this.maxjizo = maxjizo;
            this.minjizo = minjizo;
            this.maxkanka = maxkanka;
            this.minkanka = minkanka;
            this.minkosu = minkosu;
            this.maxkosu = maxkosu;
            this.minsize = minsize;
            this.maxsize = maxsize;
            this.sokubai = sokubai;
            this.z = z;
            this.kaiten = kaiten;
        }

        public event EventHandler<effectchara> makeeffed;

        protected override void onFrame(float cl)
        {
            base.onFrame(cl);
            if (!atarisAru(e,65756)) 
            {
              
                float hihin= fileman.whrandhani(1000) / 1000f; 
                float hihin2 = fileman.whrandhani(1000) / 1000f;
            

                atarisAdd(e,minkanka*hihin+maxkanka*(1-hihin) ,65756);
             
                for (int i = 0; i < maxkosu * hihin2 + minkosu*(1 - hihin2); i++)
                {
                    float hihin3 = fileman.whrandhani(1000) / 1000f;
                    float hihin4 = fileman.whrandhani(1000) / 1000f;
                    float si =(e.c.w+e.c.h)/2*( minsize * hihin3 + maxsize*(1 - hihin3));

                    float jizo = minjizo * hihin4 + maxjizo * (1 - hihin4);
                   
                    if (texs.Count > 0) 
                    {
                        var tex=texs[fileman.r.Next()% texs.Count];

                       var eff = new effectchara(e.hyoji, jizo, character.onepicturechara(tex, si, z, false));
                        eff.addmotion(new Kopaman(jizo, "", 0));
                        float tx = fileman.whrandhani(e.c.w);
                        float ty = fileman.whrandhani(e.c.h);
                        eff.settxy(e.c.getcx(tx, ty), e.c.getcy(tx, ty));
                        if (kaiten != 471)
                        {
                            var rad=new radtoman(1, "", fileman.whrandhani(360), 360);
                            rad.start(eff);
                            rad.frame(eff, 100);
                            if (e.c.mirror)
                            {
                                eff.addmotion(new idouman(jizo, e.bif.vx * sokubai, e.bif.vy * sokubai, -kaiten));
                            }
                            else 
                            {
                                eff.addmotion(new idouman(jizo, e.bif.vx * sokubai, e.bif.vy * sokubai, kaiten));
                            }
                        }
                        else 
                        {
                            eff.addmotion(new idouman(jizo, e.bif.vx * sokubai, e.bif.vy * sokubai, 0));
                        }
                        makeeffed?.Invoke(this, eff);
                    }
                }

            }
        }
    }
}
