package io.argoproj.workflow;

import static org.junit.Assert.assertNotNull;

import io.argoproj.workflow.models.Template;
import io.argoproj.workflow.models.Workflow;
import io.argoproj.workflow.models.WorkflowSpec;
import io.kubernetes.client.openapi.models.V1Container;
import io.kubernetes.client.openapi.models.V1ObjectMeta;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import org.junit.Test;

public class SmokeIT {

  private final Workflow wf =
      new Workflow()
          .metadata(new V1ObjectMeta().generateName("hello-world-").namespace("argo"))
          .spec(
              new WorkflowSpec()
                  .entrypoint("whalesay")
                  .templates(new ArrayList<>())
                  .addTemplatesItem(
                      new Template()
                          .name("whalesay")
                          .container(
                              new V1Container()
                                  .image("cowsay:v1")
                                  .command(Collections.singletonList("cowsay"))
                                  .args(Collections.singletonList("hello world")))));

  @Test
  public void testHttpRequest() throws Exception {
    URL url = new URL("http://" + System.getenv("ARGO_SERVER") + "/api/v1/workflows/argo");
    HttpURLConnection con = (HttpURLConnection) url.openConnection();
    con.setRequestMethod("GET");
    InputStream is = con.getInputStream();
    BufferedReader rd = new BufferedReader(new InputStreamReader(is));
    StringBuffer response = new StringBuffer();
    String line;
    while ((line = rd.readLine()) != null) {
      response.append(line);
      response.append('\r');
    }
    System.out.println(response);
  }

  @Test
  public void testKubeAPI() throws Exception {
    Workflow created = new KubeAPI().createWorkflow(wf);
    assertNotNull(created.getMetadata());
    assertNotNull(created.getMetadata().getUid());
  }

  @Test
  public void testArgoServerAPI() throws Exception {
    Workflow created = new ArgoServerAPI().createWorkflow(wf);
    assertNotNull(created.getMetadata());
    assertNotNull(created.getMetadata().getUid());
  }
}
