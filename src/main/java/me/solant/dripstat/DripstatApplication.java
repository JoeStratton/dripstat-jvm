package me.solant.dripstat;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(proxyBeanMethods = false)
public class DripstatApplication {

  public static void main(String[] args) {
    SpringApplication.run(DripstatApplication.class, args);
  }
}
