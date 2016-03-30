//
//  stl_shader.metal
//  stl_loader
//
//  Created by brian jones on 10/11/15.
//  Copyright © 2015 brian jones. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Output_Vertex {
    float4 pos [[position]];
    float4 col [[user(color)]];
};

struct Input_Fragment {
    float4 col [[user(color)]];
};

vertex Output_Vertex move_triangle_vertex_shader(constant float4x4 &projection_matrix [[buffer(0)]],
                                       constant float4x4 &model_matrix [[buffer(1)]],
                                       const device float4 *vertices [[buffer(2)]],
                                       uint vid [[vertex_id]]) {
    float4 v = float4(vertices[vid].xyz, 1.0);
    
    Output_Vertex output;
    output.pos = projection_matrix * model_matrix * v;
    output.col = float4(1.0, 1.0, 1.0, 1.0);
    
    return output;
}

fragment float4 move_triangle_fragment_shader(Input_Fragment frag [[stage_in]]){
    //return frag.col;
    return float4(1.0, 1.0f, 1.0, 1.0f);
}