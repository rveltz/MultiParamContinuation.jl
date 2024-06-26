using MultiParamContinuation
const MPC = MultiParamContinuation

F(u,p) = [u[1]^2 + u[2]^2 + u[3]^2 - 1] # sphere

prob = ManifoldProblem(F, 
                    [1. ,0, 0],
                    nothing;
                        )

S = MPC.continuation(prob,
        Henderson(np0 = 5,
                    use_curvature = true,
                    ),
        CoveringPar(max_charts = 20000, 
                max_steps = 250,
                verbose = 2,
                R0 = .2,
                ϵ = 10.15,
                delta_angle = 10.1,
                )
        )

Sl = length(S)

# nothing is added
MPC.step!(S, 1000)
@test length(S) == Sl
MPC.check_alphas(S, S[1])
MPC.test_P(S[1], S[2])
MPC.true_intersec_list(S, S[1])
MPC.get_alpha(S[1], S[2])

# play with bvhtree
tree = MPC.BVHNode(S)
show(tree)