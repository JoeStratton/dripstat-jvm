package me.solant.dripstat;

import java.util.concurrent.CountDownLatch;

import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationListener;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.event.ContextClosedEvent;
import org.springframework.context.annotation.Bean;

@SpringBootApplication(proxyBeanMethods = false)
public class DripstatApplication {

  public static void main(String[] args) {
    SpringApplication.run(DripstatApplication.class, args);
  }

  /**
   * Non-web Spring Boot exits once the main thread leaves {@code run()}. Block until the context
   * closes (SIGTERM / docker stop) so the container stays running for DripStat.
   */
  @Bean
  ApplicationRunner dripstatKeepAlive(ConfigurableApplicationContext context) {
    return args -> {
      CountDownLatch stopped = new CountDownLatch(1);
      context.addApplicationListener(
          (ApplicationListener<ContextClosedEvent>) event -> stopped.countDown());
      try {
        stopped.await();
      } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
      }
    };
  }
}
