package com.example.demo;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {
    @RequestMapping("/")
    public String home(){
        return "This is the homepage";
    }
    @RequestMapping("/objects")
    public String index() {
        return "This is the route for object detection";
    }
    @RequestMapping("/translate")
    public String index() {
        return "This is the route for language translation";
}
