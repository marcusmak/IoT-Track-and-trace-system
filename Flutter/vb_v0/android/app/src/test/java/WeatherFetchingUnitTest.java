//import com.google.common.truth.Truth.assertThat;
import android.content.Context;

import androidx.test.core.app.ApplicationProvider;
import com.example.vb_v0.alarm.service.util.WeatherInfoManager;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import static org.mockito.Mockito.mock;

@RunWith(MockitoJUnitRunner.class)
public class WeatherFetchingUnitTest {
    @Mock
    Context context = mock(Context.class);

    @Test
    public void weatherFetchingTrial(){
        WeatherInfoManager testWIM = new WeatherInfoManager(context);
        testWIM.FetchDayForecast(0,"EX4");
        System.out.println("testing online");
    }
}
