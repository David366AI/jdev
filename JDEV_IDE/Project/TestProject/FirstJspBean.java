

public class FirstJspBean
{
    protected String sample = "Start value";
    //Access sampleproperty
    public String getSample()
    {
        DbTest t;
        return sample;
    }
    //Access sample property
    public void setSample(String newValue)
    {
        if (newValue!=null)
        {
            sample = newValue  ;
        }
    }

}
class test extends FirstJspBean
{
    public String k;
    public static void test()
    {}
}



