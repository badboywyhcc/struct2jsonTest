//
//  main.m
//  struct2jsonTest
//
//  Created by 韩帆 on 2019/4/10.
//  Copyright © 2019 hancc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "s2j.h"
#include <stdint.h>
#include <stdio.h>

typedef struct {
    char name[16];
} Hometown;

typedef struct {
    uint8_t iden;
    double weight;
    uint8_t score[8];
    char name[10];
    Hometown hometown;
} Student;

/**
 * Student JSON object to structure object
 */
static void *json_to_struct(cJSON* json_obj) {
    /* create Student structure object */
    s2j_create_struct_obj(struct_student, Student);
    
    /* deserialize data to Student structure object. */
    s2j_struct_get_basic_element(struct_student, json_obj, int, iden);
    s2j_struct_get_array_element(struct_student, json_obj, int, score);
    s2j_struct_get_basic_element(struct_student, json_obj, string, name);
    s2j_struct_get_basic_element(struct_student, json_obj, double, weight);
    
    /* deserialize data to Student.Hometown structure object. */
    s2j_struct_get_struct_element(struct_hometown, struct_student, json_hometown, json_obj, Hometown, hometown);
    s2j_struct_get_basic_element(struct_hometown, json_hometown, string, name);
    
    /* return Student structure object pointer */
    return struct_student;
}

/**
 * Student structure object to JSON object
 */
static cJSON *struct_to_json(void* struct_obj) {
    Student *struct_student = (Student *)struct_obj;
    
    /* create Student JSON object */
    s2j_create_json_obj(json_student);
    
    /* serialize data to Student JSON object. */
    s2j_json_set_basic_element(json_student, struct_student, int, iden);
    s2j_json_set_basic_element(json_student, struct_student, double, weight);
    s2j_json_set_array_element(json_student, struct_student, int, score, 8);
    s2j_json_set_basic_element(json_student, struct_student, string, name);
    
    /* serialize data to Student.Hometown JSON object. */
    s2j_json_set_struct_element(json_hometown, json_student, struct_hometown, struct_student, Hometown, hometown);
    s2j_json_set_basic_element(json_hometown, struct_hometown, string, name);
    
    /* return Student JSON object pointer */
    return json_student;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        static Student orignal_student_obj = {
            .iden = 24,
            .weight = 71.2,
            .score = {1, 2, 3, 4, 5, 6, 7, 8},
            .name = "armink",
            .hometown.name = "China",
        };
        
        /* serialize Student structure object 结构体转化为json字符串*/
        cJSON *json_student = struct_to_json(&orignal_student_obj);
        
        //将json结构格式化到缓冲区
        char *buf = cJSON_Print(json_student);
        printf("data:%s\n",buf = cJSON_Print(json_student));
        free(buf);
        
        
        /* deserialize Student structure object json字符串转化为结构体*/
        Student *converted_student_obj = json_to_struct(json_student);
        
        /* compare Student structure object */
        if(memcmp(&orignal_student_obj, converted_student_obj, sizeof(Student))) {
            printf("Converted failed!\n");
        } else {
            printf("iden:%d\n",converted_student_obj->iden);
            printf("Converted OK!\n");
        }
        
        
        s2j_delete_json_obj(json_student);
        s2j_delete_struct_obj(converted_student_obj);
    }
    return 0;
}
