import Mathlib

/- Fredholm Operators over a fixed field enable notation. -/
open Function Set Classical

section

/-Remark: During the project, I would like to work in the field ℝ. I am not familiar
with functional analysis over other normed fields. But, In the definition I can still
consider general normed fields-/
class FredholmOperators
  {𝕜 : Type*} [NontriviallyNormedField 𝕜]
  {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace 𝕜 F]
  [CompleteSpace F] [CompleteSpace E]
  (f : E →L[𝕜] F) : Prop :=
    (finite_dimensional_kernel : FiniteDimensional 𝕜 (LinearMap.ker f))
    (closed_range : IsClosed (LinearMap.range f:Set F))
    (finite_dimensional_cokernel : FiniteDimensional 𝕜 (F ⧸ LinearMap.range (f)))

/-- Fred(X, Y) is the set of Fredholm operators between X and Y -/
def Fred
  {𝕜 : Type*} [NontriviallyNormedField 𝕜]
  (E : Type*) [NormedAddCommGroup E] [NormedSpace 𝕜 E]
  (F : Type*) [NormedAddCommGroup F] [NormedSpace 𝕜 F]
  [CompleteSpace E] [CompleteSpace F] :
  Set (E →L[𝕜] F) :={ f | FredholmOperators f }

namespace FredholmOperators
/-- Kernel of a Fredholm operator -/
def ker {𝕜 : Type*} [NontriviallyNormedField 𝕜]
  {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace 𝕜 F]
  [CompleteSpace F] [CompleteSpace E]
  (f : E →L[𝕜] F): Submodule 𝕜 E :=
    LinearMap.ker f

/-- Range of a Fredholm operator -/
def ran {𝕜 : Type*} [NontriviallyNormedField 𝕜]
  {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace 𝕜 F]
  [CompleteSpace F] [CompleteSpace E]
  (f : E →L[𝕜] F): Submodule 𝕜 F :=
    LinearMap.range f

/-- Cokernel of a Fredholm operator -/
def coker {𝕜 : Type*} [NontriviallyNormedField 𝕜]
  {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace 𝕜 F]
  [CompleteSpace F] [CompleteSpace E]
  (f : E →L[𝕜] F) :Module 𝕜 (F ⧸ LinearMap.range (f)) :=
    Submodule.Quotient.module (LinearMap.range f)

noncomputable def ind {𝕜 : Type*} [NontriviallyNormedField 𝕜]
  {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace 𝕜 F]
  [CompleteSpace F] [CompleteSpace E]
  (f : E →L[𝕜] F) [FredholmOperators f] : ℤ :=
      Module.finrank 𝕜 (ker f) - Module.finrank 𝕜 (F ⧸ ran f)
      /-The Module.finrank is non-computable-/
end FredholmOperators

/-Lemma: Let T : X → Y be a operator so that the range admits a closed
complementary subspace. Then the range of T is closed.-/
lemma RangeClosedIfAdmittingRangeClosedCompletement
  {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
  (f : E →L[ℝ] F) [CompleteSpace F] [CompleteSpace E]
  (h : ∃ C : Subspace ℝ F, IsClosed (C : Set F) ∧
      ∀ y : F, ∃ u c : F,
        u ∈ LinearMap.range f ∧
        c ∈ C ∧ u + c = y ∧
        ∀ u' c' : F,
          u' ∈ LinearMap.range f ∧ c' ∈ C ∧ u' + c' = y → u' = u ∧ c' = c) :
  IsClosed (LinearMap.range f : Set F):=sorry

/-Theorem: If T : X → Y is a bounded invertible operator then for all
p : X → Y with sufficiently small norm T + p is also invertible.-/
theorem BoundedInvertibleOperatorPlusεIsInvertible
  {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
  (f : E →L[ℝ] F)[CompleteSpace E] [CompleteSpace F]
  (hT_inv : ∃ f_inv : F →L[ℝ] E, f.comp f_inv = ContinuousLinearMap.id ℝ F ∧ f_inv.comp f = ContinuousLinearMap.id ℝ E)
  :∃ε :ℝ ,ε>0 ∧
  ∀ (p:E →L[ℝ] F) ,‖p‖ < ε →
    ∃ S_inv : F →L[ℝ] E,(f + p).comp S_inv = ContinuousLinearMap.id ℝ F ∧
    S_inv.comp (f + p) = ContinuousLinearMap.id ℝ E :=sorry

/-(Riesz Theorem): The unit ball B in a Banach space X is compact if and
only if B is finite dimensional.-/
/-Omitted. Since Riesz Theorem is already in mathlib-/

/-Lemma: The following are equivalent:
1. ker(T) is finite dimensional and Ran(T) is closed.
2. Every bounded sequence {xᵢ} ⊆ X with Txᵢ convergent has a convergent
subsequence.-/
lemma FinDimKerAndClosedRanCriterion
  {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
  [CompleteSpace E] [CompleteSpace F]:
  ∀(f : E →L[ℝ] F),
    (FiniteDimensional ℝ  (LinearMap.ker f)) ∧ IsClosed (LinearMap.range f:Set F)↔
    (∀ (x_seq : ℕ → E) (h_bounded : ∃ C, ∀ n, ‖x_seq n‖ ≤ C),
      (h_convergent : ∃ y : F, Filter.Tendsto (λ n↦ f (x_seq n)) Filter.atTop (nhds y))→
      ∃ x_subseq : ℕ → E, ∃ φ : ℕ → ℕ,
        x_subseq=x_seq ∘ φ ∧
        StrictMono φ ∧
        ∃ y : E, Filter.Tendsto (x_subseq) Filter.atTop (nhds (y))) :=sorry

/-Theorem: Fred(X,Y) is a open subset of B(X,Y)-/
theorem OpennessFredholm
  {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
  [CompleteSpace E] [CompleteSpace F]:
  IsOpen ((Fred E F):Set (E →L[ℝ] F))
  :=sorry

/-Theorem: the index is a locally constant function on Fred(X, Y)-/
theorem IndexLocallyConstantFredholm
  {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
  [CompleteSpace E] [CompleteSpace F]
  (f : (E →L[ℝ] F)) [FredholmOperators f]:
  ∃ (U : Set (E →L[ℝ] F)), IsOpen U ∧ f ∈ U ∧
  (∀g[FredholmOperators g], g∈ U→ FredholmOperators.ind f = FredholmOperators.ind g ):=sorry

/-Lemma: Let T : X → Y be a Fredholm map and p : X → Y a linear map.
If p has sufficiently small norm then there are isomorphisms i: X'⊕ K → X and
j: Y → X'⊕C so that j◦(T + p)◦i is the diag(id_{X'} q) for some q: K → C -/
lemma DecompositionOfFredholmPlusε
  {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F] [CompleteSpace F]
  (f : (E →L[ℝ] F)) [FredholmOperators f]:
  ∃(ε:ℝ),ε>0∧ ∀(p:E→L[ℝ] F),‖p‖<ε →
    ∃ (E' : Type*) ,∃_:NormedAddCommGroup E' ,∃_:NormedSpace ℝ E',
    ∃ (K : Type*) ,∃_:NormedAddCommGroup K ,∃_:NormedSpace ℝ K,
    ∃ (C : Type*) ,∃_:NormedAddCommGroup C ,∃_:NormedSpace ℝ C,
    ∃ (i :  (E'× K)≃L[ℝ] E), ∃(j: F≃L[ℝ] E'×C), ∃ q:K →L[ℝ] C,
      j∘ (f + p) ∘ i = λ⟨a,b⟩↦⟨a,q b⟩:=by sorry



end
