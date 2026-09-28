package bestiary

import "context"

type Service struct{ repository Repository }

func NewService(repository Repository) *Service { return &Service{repository: repository} }

func (s *Service) Options(ctx context.Context) (Options, error) {
	return s.repository.Options(ctx)
}

func (s *Service) List(ctx context.Context, filter Filters) (Page, error) {
	return s.repository.List(ctx, filter)
}

func (s *Service) Get(ctx context.Context, id string, filter Filters) (Detail, error) {
	creature, navigation, err := s.repository.Get(ctx, id, filter)
	if err != nil {
		return Detail{}, err
	}
	return Detail{Creature: creature, Navigation: navigation}, nil
}

