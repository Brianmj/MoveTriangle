//
//  metaldrawer.swift
//  metal_drawer
//
//  Created by brian jones on 10/23/15.
//  Copyright © 2015 brian jones. All rights reserved.
//

import UIKit
import Foundation
import Metal
import QuartzCore

class MetalRenderer : NSObject {

    var triangleBuffer: MTLBuffer! = nil
    var projectionBuffer: MTLBuffer!
    var modelMatrixBuffer: MTLBuffer!
    var translate: Matrix!
    let semaphore = dispatch_semaphore_create(1)
    
    func draw(){
        
        let drawable = layer.nextDrawable()
        let renderTexture = drawable?.texture
        renderPassDesc.colorAttachments[0].texture = renderTexture
        let commandBuffer = queue.commandBuffer()
        let encoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDesc)
        
        let c = modelMatrixBuffer.contents()
        memcpy(c, translate.array, translate.count * sizeof(Float))
        
        encoder.setRenderPipelineState(pipelineObject)
        encoder.setVertexBuffer(projectionBuffer, offset: 0, atIndex: 0)
        encoder.setVertexBuffer(modelMatrixBuffer, offset: 0, atIndex: 1)
        encoder.setVertexBuffer(triangleBuffer, offset: 0, atIndex: 2)
        
        encoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: 3)
        
        encoder.endEncoding()
        commandBuffer.presentDrawable(drawable!)
        commandBuffer.commit()
    }
    
    func setup() {
        load_shaders()
        
        let frame = layer.frame
        
        let ortho = Matrix.superbible7OrthoMatrix(0.0, right: frame.width, bottom: frame.height, top: 0.0, near: 0.1, far: 100.0)
        
        projectionBuffer = device.newBufferWithBytes(ortho, length: sizeof(Float) * ortho.count, options: [])
        
        translate = Matrix.translate(Float(frame.width / 2), y: Float(frame.height / 2), z: 1.0)
        
        modelMatrixBuffer = device.newBufferWithBytes(translate.array, length: sizeof(Float) * translate.count, options: [])
        
        let vertices: [Float] = [0.0, 25.0, 0.0, 1.0,
                                -25.0, -25.0, 0.0, 1.0,
                                25.0, -25.0, 0.0, 1.0]
        
        triangleBuffer = device.newBufferWithBytes(vertices, length: sizeof(Float) * vertices.count, options: [.CPUCacheModeDefaultCache])
        
        timer = CADisplayLink(target: self, selector: Selector("execute"))
        timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
    }
    
    func update(){
        
    }
    
    func load_shaders() {
        let lib = device.newDefaultLibrary()
        let vertexFunction = lib?.newFunctionWithName("move_triangle_vertex_shader")
        let fragmentFunction = lib?.newFunctionWithName("move_triangle_fragment_shader")
        let pipelineDesc = MTLRenderPipelineDescriptor()
        pipelineDesc.colorAttachments[0].pixelFormat = .BGRA8Unorm
        pipelineDesc.vertexFunction = vertexFunction
        pipelineDesc.fragmentFunction = fragmentFunction
        pipelineDesc.depthAttachmentPixelFormat = .Depth32Float
        
        do {
            pipelineObject = try device.newRenderPipelineStateWithDescriptor(pipelineDesc)
        }catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch?.locationInView(touch?.view)
        translate = Matrix.translate(Float(location!.x), y: Float(location!.y), z: 1.0)

    }
    
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch?.locationInView(touch?.view)
        translate = Matrix.translate(Float(location!.x), y: Float(location!.y), z: 1.0)
    }
    
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
    }
    
    init(vc: UIViewController) {
        device = MTLCreateSystemDefaultDevice()
        queue = device.newCommandQueue()
        layer = CAMetalLayer()
        layer.device = device
        layer.framebufferOnly = true
        layer.frame = vc.view.layer.frame
        layer.pixelFormat = .BGRA8Unorm
        vc.view.layer.addSublayer(layer)
        
        let depthTextureDesc = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(.Depth32Float, width: Int(vc.view.layer.frame.width), height: Int(vc.view.layer.frame.height), mipmapped: false)
        depthTexture = device.newTextureWithDescriptor(depthTextureDesc)
        
        depthTextureAttachment = MTLRenderPassDepthAttachmentDescriptor()
        depthTextureAttachment.clearDepth = 1.0
        depthTextureAttachment.storeAction = .Store
        depthTextureAttachment.loadAction = .Clear
        depthTextureAttachment.texture = depthTexture
        
        renderPassDesc = MTLRenderPassDescriptor()
        renderPassDesc.depthAttachment = depthTextureAttachment
        renderPassDesc.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 1.0, 1.0, 1.0)
        renderPassDesc.colorAttachments[0].loadAction = .Clear
        renderPassDesc.colorAttachments[0].storeAction = .Store
        
        super.init()
        setup()
    }
    
    func execute() {
        update()
        draw()
    }
    
    var device: MTLDevice!
    var queue: MTLCommandQueue!
    var pipelineObject: MTLRenderPipelineState!
    var renderPipelineDesc: MTLRenderPipelineDescriptor!
    var layer: CAMetalLayer!
    var depthTexture: MTLTexture!
    var depthTextureAttachment: MTLRenderPassDepthAttachmentDescriptor!
    var renderPassDesc: MTLRenderPassDescriptor!
    var timer: CADisplayLink!
    
}